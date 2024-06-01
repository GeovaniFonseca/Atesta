import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../../../services/DatabaseService.dart';
import '../widgets/user_info_card.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final DatabaseService databaseService = DatabaseService();
  String? profileImageUrl;
  String? selectedDependent;
  List<String> dependents = [];
  TextEditingController dependentController = TextEditingController();

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

  Future<void> _updateProfilePicture(BuildContext context) async {
    var imageUrl = await databaseService.updateProfilePicture(context);
    if (imageUrl != null) {
      setState(() {
        profileImageUrl = imageUrl;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    var profileData = await databaseService.loadProfileData();
    setState(() {
      profileImageUrl = profileData['profileImageUrl'];
      dependents = profileData['dependents'];
      selectedDependent = profileData['selectedDependent'];
    });
  }

  void _showAddDependentDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Adicionar Dependente"),
          content: TextField(
            controller: dependentController,
            decoration: const InputDecoration(
              hintText: "Nome do Dependente",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancelar"),
            ),
            TextButton(
              onPressed: () async {
                await databaseService.addDependent(dependentController.text);
                dependentController.clear();
                await _loadProfileData();
                Navigator.of(context).pop();
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

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
              await FirebaseAuth.instance.signOut();
              if (mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.exit_to_app_rounded,
                  color: Color.fromARGB(255, 38, 87, 151),
                ),
                SizedBox(width: 4),
                Text(
                  'Sair',
                  style: TextStyle(color: Color.fromARGB(255, 38, 87, 151)),
                ),
              ],
            ),
          ),
        ],
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(FirebaseAuth.instance.currentUser?.uid)
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
                              : const AssetImage(
                                      'lib/assets/images/DefaultProfile.png')
                                  as ImageProvider,
                        ),
                        Positioned(
                          bottom: -10,
                          left: 80,
                          child: IconButton(
                            icon: const Icon(Icons.add_a_photo),
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
                    DropdownButton<String>(
                      value: selectedDependent,
                      hint: const Text("Selecione um dependente"),
                      items: [
                        ...dependents.map((String dependent) {
                          return DropdownMenuItem<String>(
                            value: dependent,
                            child: Text(dependent),
                          );
                        }).toList(),
                        DropdownMenuItem<String>(
                          value: "add_new",
                          child: const Text("Adicionar novo dependente"),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue == "add_new") {
                          _showAddDependentDialog();
                        } else {
                          databaseService.updateSelectedDependent(newValue);
                          setState(() {
                            selectedDependent = newValue;
                          });
                        }
                      },
                    ),
                    const SizedBox(height: 10),
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
