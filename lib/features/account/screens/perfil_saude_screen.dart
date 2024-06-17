import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HealthProfileEditScreen extends StatefulWidget {
  final Map<String, dynamic> userData;

  const HealthProfileEditScreen({super.key, required this.userData});

  @override
  // ignore: library_private_types_in_public_api
  _HealthProfileEditScreenState createState() =>
      _HealthProfileEditScreenState();
}

class _HealthProfileEditScreenState extends State<HealthProfileEditScreen> {
  String? bloodType;
  String? bloodDonor;
  String? organDonor;
  String? exercises;
  TextEditingController weightController = TextEditingController();
  TextEditingController heightController = TextEditingController();

  @override
  void initState() {
    super.initState();
    bloodType = widget.userData['bloodType'];
    bloodDonor = widget.userData['bloodDonor'];
    organDonor = widget.userData['organDonor'];
    exercises = widget.userData['exercises'];
    weightController.text = widget.userData['weight'] ?? '';
    heightController.text = widget.userData['height'] ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Perfil de Saúde'),
        actions: [
          TextButton(
            onPressed: () async {
              await FirebaseFirestore.instance
                  .collection('Users')
                  .doc(FirebaseAuth.instance.currentUser?.uid)
                  .update({
                'bloodType': bloodType,
                'bloodDonor': bloodDonor,
                'organDonor': organDonor,
                'weight': weightController.text,
                'height': heightController.text,
                'exercises': exercises,
              });
              // ignore: use_build_context_synchronously
              Navigator.of(context).pop();
            },
            child: const Text(
              'Salvar',
              style: TextStyle(color: Colors.amber),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Qual o seu tipo sanguíneo?'),
              Wrap(
                spacing: 10.0,
                children: ['O-', 'O+', 'A-', 'A+', 'B-', 'B+', 'AB-', 'AB+']
                    .map((type) => ChoiceChip(
                          label: Text(type),
                          selected: bloodType == type,
                          onSelected: (selected) {
                            setState(() {
                              bloodType = selected ? type : null;
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('Você é doador de sangue?'),
              Wrap(
                spacing: 10.0,
                children: ['Sim', 'Não', 'Ainda não decidi']
                    .map((choice) => ChoiceChip(
                          label: Text(choice),
                          selected: bloodDonor == choice,
                          onSelected: (selected) {
                            setState(() {
                              bloodDonor = selected ? choice : null;
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('Você é doador de órgãos?'),
              Wrap(
                spacing: 10.0,
                children: ['Sim', 'Não', 'Ainda não decidi']
                    .map((choice) => ChoiceChip(
                          label: Text(choice),
                          selected: organDonor == choice,
                          onSelected: (selected) {
                            setState(() {
                              organDonor = selected ? choice : null;
                            });
                          },
                        ))
                    .toList(),
              ),
              const SizedBox(height: 20),
              const Text('Atividade física'),
              Wrap(
                spacing: 10.0,
                children: ['Intensa', 'Moderada', 'Sedentária']
                    .map((activity) => ChoiceChip(
                          label: Text(activity),
                          selected: exercises == activity,
                          onSelected: (selected) {
                            setState(() {
                              exercises = selected ? activity : null;
                            });
                          },
                        ))
                    .toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
