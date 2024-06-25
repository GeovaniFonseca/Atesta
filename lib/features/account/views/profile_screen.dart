// lib/views/profile_screen.dart
// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hello_world/features/account/widgets/code_generator.dart';
import 'edit_profile_screen.dart';
import 'perfil_saude_screen.dart';
import '../widgets/health_user_card.dart';
import '../widgets/user_info_card.dart';
import '../viewmodels/profile_viewmodel.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController dependentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<ProfileViewModel>(context, listen: false).loadProfileData();
  }

  void _showAddDependentDialog(BuildContext context) {
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
                await Provider.of<ProfileViewModel>(context, listen: false)
                    .addDependent(dependentController.text);
                dependentController.clear();
                Navigator.of(context).pop();
              },
              child: const Text("Adicionar"),
            ),
          ],
        );
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Perfil",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
        centerTitle: true,
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
      body: Consumer<ProfileViewModel>(
        builder: (context, viewModel, child) {
          return StreamBuilder<DocumentSnapshot>(
            stream: FirebaseFirestore.instance
                .collection('Users')
                .doc(FirebaseAuth.instance.currentUser?.uid)
                .snapshots(),
            builder: (BuildContext context,
                AsyncSnapshot<DocumentSnapshot> snapshot) {
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

              return Padding(
                padding: const EdgeInsets.all(16.0),
                child: CustomScrollView(
                  slivers: <Widget>[
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Stack(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.grey.shade300,
                                radius: 64,
                                backgroundImage: viewModel.profileImageUrl !=
                                        null
                                    ? NetworkImage(viewModel.profileImageUrl!)
                                    : const AssetImage(
                                            'lib/assets/images/DefaultProfile.png')
                                        as ImageProvider,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.add_a_photo,
                                    color: Color.fromARGB(255, 0, 0, 0),
                                  ),
                                  onPressed: () =>
                                      viewModel.updateProfilePicture(context),
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
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.grey,
                                width: 2,
                              ),
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: viewModel.dependents
                                        .contains(viewModel.selectedDependent)
                                    ? viewModel.selectedDependent
                                    : null,
                                hint: const Text(
                                  "Selecione um dependente",
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                                items: [
                                  ...viewModel.dependents
                                      .map((String dependent) {
                                    return DropdownMenuItem<String>(
                                      value: dependent,
                                      child: Text(
                                        dependent,
                                        style: const TextStyle(
                                          color: Colors.black,
                                          fontSize: 16,
                                        ),
                                      ),
                                    );
                                  }),
                                  const DropdownMenuItem<String>(
                                    value: "add_new",
                                    child: Text(
                                      "Adicionar novo dependente",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontSize: 16,
                                      ),
                                    ),
                                  ),
                                ],
                                onChanged: (String? newValue) {
                                  if (newValue == "add_new") {
                                    _showAddDependentDialog(context);
                                  } else {
                                    viewModel.updateSelectedDependent(newValue);
                                  }
                                },
                                dropdownColor: Colors.white,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                                icon: const Icon(
                                  Icons.arrow_drop_down,
                                  color: Color.fromARGB(255, 187, 187, 187),
                                ),
                                iconEnabledColor: Colors.blue,
                                iconDisabledColor: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              surfaceTintColor: Colors.white,
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 38, 87, 151),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        EditProfileScreen(userData: userData)),
                              );
                            },
                            child: const Text(
                              'Editar Perfil',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              elevation: 10,
                              surfaceTintColor: Colors.white,
                              foregroundColor: Colors.white,
                              backgroundColor:
                                  const Color.fromARGB(255, 38, 87, 151),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) => const CodeScreen()),
                              );
                            },
                            child: const Text(
                              'Código de compartilhamento',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 10),
                        ],
                      ),
                    ),
                    SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
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
                    SliverToBoxAdapter(
                      child: Column(
                        children: [
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Perfil de Saúde',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              TextButton(
                                onPressed: () => Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HealthProfileEditScreen(
                                      userData: userData,
                                    ),
                                  ),
                                ),
                                child: const Text(
                                  'Editar',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 38, 87, 151),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 3,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                            childAspectRatio: 1,
                            children: [
                              HealthInfoCard(
                                icon: Icons.bloodtype,
                                label: 'Tipo sanguíneo',
                                value: userData['bloodType'] ?? 'N/D',
                              ),
                              HealthInfoCard(
                                icon: Icons.bloodtype,
                                label: 'Doador de sangue',
                                value: userData['bloodDonor'] ?? 'N/D',
                              ),
                              HealthInfoCard(
                                icon: Icons.luggage,
                                label: 'Doador de órgãos',
                                value: userData['organDonor'] ?? 'N/D',
                              ),
                              HealthInfoCard(
                                icon: Icons.monitor_weight,
                                label: 'Peso',
                                value: userData['weight'] ?? 'N/D',
                              ),
                              HealthInfoCard(
                                icon: Icons.height,
                                label: 'Altura',
                                value: userData['height'] ?? 'N/D',
                              ),
                              HealthInfoCard(
                                icon: Icons.fitness_center,
                                label: 'Exercícios',
                                value: userData['exercises'] ?? 'N/D',
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
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
