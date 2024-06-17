import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:math';

class CodeScreen extends StatefulWidget {
  const CodeScreen({Key? key}) : super(key: key);

  @override
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
        title: const Text('Generated Code'),
      ),
      body: Center(
        child: _isLoading
            ? const CircularProgressIndicator()
            : Text(
                'Seu código: $_generatedCode',
                style: const TextStyle(fontSize: 24),
              ),
      ),
    );
  }
}
