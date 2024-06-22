import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class CodeScreen extends StatefulWidget {
  const CodeScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CodeScreenState createState() => _CodeScreenState();
}

class _CodeScreenState extends State<CodeScreen> {
  String _generatedCode = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkAndGenerateCode();
  }

  String _generateRandomCode(int length) {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        length, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }

  Future<void> _checkAndGenerateCode() async {
    String? userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId != null) {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('Users') // Certifique-se de usar a coleção correta
          .doc(userId)
          .get();

      if (userDoc.exists) {
        var userData = userDoc.data() as Map<String, dynamic>;
        Timestamp? lastGenerated = userData['lastGenerated'];
        if (lastGenerated != null) {
          DateTime now = DateTime.now();
          DateTime lastGeneratedTime = lastGenerated.toDate();
          Duration difference = now.difference(lastGeneratedTime);

          if (difference.inHours < 2) {
            setState(() {
              _generatedCode = userData['code'];
              _isLoading = false;
            });
            return;
          }
        }
      }

      // Generate new code if the last generated code is older than 2 hours or doesn't exist
      String newCode = _generateRandomCode(8);
      await FirebaseFirestore.instance.collection('Users').doc(userId).set({
        'code': newCode,
        'lastGenerated': Timestamp.now(),
      }, SetOptions(merge: true));

      setState(() {
        _generatedCode = newCode;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Código de compartilhamento',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor:
            const Color.fromARGB(255, 255, 255, 255), // Mudança de cor
        foregroundColor: const Color.fromARGB(255, 38, 87, 151),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _isLoading
              ? const CircularProgressIndicator()
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 40,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Compartilho esse código apenas com o seu médico!',
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    Text(
                      'Seu código:',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.grey.shade700,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blueAccent),
                      ),
                      child: Text(
                        _generatedCode,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 0, 0, 0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    const Text(
                      'O que fazer com este código:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      '1. Acesse o site www.atesta.com.br\n'
                      '2. Digite o código no campo "Mostrar Informações"',
                      style: TextStyle(
                        fontSize: 16,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
