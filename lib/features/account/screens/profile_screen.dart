import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../../../services/DatabaseService.dart';
import '../widgets/user_info_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  IconData getIconForKey(String key) {
    switch (key) {
      case 'name':
        return Icons.person;
      case 'age':
        return Icons.cake;
      case 'phone':
        return Icons.phone;
      case 'email':
        return Icons.email;
      default:
        return Icons.device_unknown;
    }
  }

  Map<String, Color> cardColors = {
    'name': const Color.fromARGB(255, 217, 242, 255),
    'age': const Color.fromARGB(255, 217, 230, 255),
    'phone': const Color.fromARGB(255, 230, 255, 223),
    'email': const Color.fromARGB(255, 255, 242, 216),
  };

  Future<void> _uploadImage(File image) async {
    try {
      final ref = firebase_storage.FirebaseStorage.instance
          .ref('profile_pictures/${auth.currentUser?.uid}.jpg');

      await ref.putFile(image);

      final imageUrl = await ref.getDownloadURL();

      await firestore.collection('Users').doc(auth.currentUser?.uid).update({
        'profile_picture': imageUrl,
      });

      setState(() {
        profileImageUrl = imageUrl;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> _updateProfilePicture(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Escolha a origem da imagem"),
        actions: <Widget>[
          TextButton(
            child: Text("Câmera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: Text("Galeria"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) return;

    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      _uploadImage(File(pickedFile.path));
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialProfileImage();
  }

  Future<void> _loadInitialProfileImage() async {
    var userDoc =
        await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    var userData = userDoc.data();
    if (userData != null && userData['profile_picture'] != null) {
      setState(() {
        profileImageUrl = userData['profile_picture'];
      });
    }
  }

  String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PROFILE'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: <Widget>[
          TextButton(
            onPressed: () async {
              await logout();
              // Substitua abaixo com a sua lógica de navegação, como por exemplo:
              if (mounted) {
                // Checa se o widget ainda está no tree de widgets
                Navigator.of(context).pushReplacementNamed(
                    '/login'); // Substitua '/login' pela rota da sua tela de login.
              }
            },
            child: const Text('Sair', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: firestore
            .collection('Users')
            .doc(auth.currentUser?.uid)
            .snapshots(),
        builder:
            (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("Something went wrong"));
          }

          if (!snapshot.hasData || snapshot.data?.exists != true) {
            return const Center(child: Text("Document does not exist"));
          }

          var userData = snapshot.data!.data() as Map<String, dynamic>?;
          if (userData == null) {
            return const Center(child: Text("User data is not available"));
          }

          return CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    Stack(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 64,
                          backgroundImage: profileImageUrl != null
                              ? NetworkImage(profileImageUrl!)
                              : AssetImage(
                                      'lib/assets/images/DefaultProfile.png')
                                  as ImageProvider,
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            icon: Icon(Icons.add_a_photo),
                            onPressed: () => _updateProfilePicture(context),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10),
                    Center(
                      child: Text(
                        userData['name'],
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
              SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 3 / 1.9,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    List<String> keys = ['name', 'age', 'phone', 'email'];
                    if (index >= keys.length) return null;
                    String key = keys[index];
                    dynamic rawValue = userData[key];
                    String value = rawValue.toString();
                    IconData icon = getIconForKey(key);
                    Color backgroundColor =
                        cardColors[key] ?? Colors.blue.shade100;

                    return UserInfoCard(
                      icon: icon,
                      title: key.capitalize(),
                      subtitle: value,
                      color: backgroundColor,
                    );
                  },
                  childCount: 4,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return "";
    return "${this[0].toUpperCase()}${substring(1).toLowerCase()}";
  }
}
