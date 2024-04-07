// ignore_for_file: file_names, avoid_print


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../firebase_options.dart';


class DatabaseService {
  final String _baseUrl =
      'https://projetinho-c043f-default-rtdb.firebaseio.com/users.json';

  Future<void> addUser(Map<String, dynamic> userData) async {
    final response =
        await http.post(Uri.parse(_baseUrl), body: json.encode(userData));
    if (response.statusCode != 200) {
      // Trata a resposta não bem-sucedida aqui.
    } else {
      // Usuário adicionado com sucesso.
    }
  }
}

// Acessar a aplicação
login(email, password) async {
  await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform); //busca configs de token
  FirebaseAuth auth = FirebaseAuth.instance; //inicia firebase
  try {
    await auth.signInWithEmailAndPassword(email: email, password: password);
    if (auth.currentUser != null) {
      print('login deu boa');
      return true;
    } else {
      print('Deu ruim');
      return false;
    }
  } catch (e) {
    return false;
  }

  
}

// Realizar logout
Future<void> logout() async {
  // Não é necessário inicializar o Firebase aqui novamente se já foi inicializado.
  FirebaseAuth auth = FirebaseAuth.instance;
  await auth.signOut();
  // Aqui você pode adicionar a navegação de volta para a tela de login
}

Future<void> register(
    String email, String password, String name, String phone, int age) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseAuth auth = FirebaseAuth.instance;

  // Capture the UserCredential from the createUser call
  UserCredential userCredential = await auth.createUserWithEmailAndPassword(
      email: email, password: password);

  // Use the `user` from UserCredential
  if (userCredential.user != null) {
    await registerInfo(userCredential.user!.uid, name, email, phone, age);
  }
}

Future<void> registerInfo(
    String uid, String name, String email, String phone, int age) async {
  // Initialize Firebase again is unnecessary if it's already been initialized in `register`
  FirebaseFirestore db = FirebaseFirestore.instance;
  await db.collection('Users').doc(uid).set({
    'name': name,
    'email': email,
    'phone': phone,
    'age': age,
  });
}

