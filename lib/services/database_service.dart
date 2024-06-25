// ignore_for_file: file_names, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../features/account/models/user_model.dart';
import '../features/atestado/model/atestado_model.dart';
import '../features/exame/model/exame_model.dart';
import '../features/vacina/model/vacina.dart';
import '../firebase_options.dart';

class DatabaseService {
  // final String _baseUrl =
  //     'https://projetinho-c043f-default-rtdb.firebaseio.com/users.json';

  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  // profile

  Future<bool> login(String email, String password) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    try {
      await auth.signInWithEmailAndPassword(email: email, password: password);
      return auth.currentUser != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> logout() async {
    await auth.signOut();
  }

  Future<void> register(
      String email, String password, String name, String phone, int age) async {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: email, password: password);
    if (userCredential.user != null) {
      await registerInfo(userCredential.user!.uid, name, email, phone, age);
    }
  }

  Future<void> registerInfo(
      String uid, String name, String email, String phone, int age) async {
    await firestore.collection('Users').doc(uid).set({
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
    });
  }

  Future<UserModel?> getUserData() async {
    var userDoc =
        await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    var userData = userDoc.data();
    if (userData != null) {
      return UserModel.fromMap(userData, userDoc.id);
    }
    return null;
  }

  Future<String?> getProfileImageUrl() async {
    var userDoc =
        await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    var userData = userDoc.data();
    if (userData != null && userData['profile_picture'] != null) {
      return userData['profile_picture'];
    }
    return null;
  }

  Future<String?> uploadProfileImage(File image) async {
    try {
      final ref = FirebaseStorage.instance
          .ref('profile_pictures/${auth.currentUser?.uid}.jpg');

      await ref.putFile(image);
      final imageUrl = await ref.getDownloadURL();

      await firestore.collection('Users').doc(auth.currentUser?.uid).update({
        'profile_picture': imageUrl,
      });

      return imageUrl;
    } catch (e) {
      print(e);
      return null;
    }
  }

  Future<String?> updateProfilePicture(BuildContext context) async {
    final picker = ImagePicker();
    final source = await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Escolha a origem da imagem"),
        actions: <Widget>[
          TextButton(
            child: const Text("Câmera"),
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: const Text("Galeria"),
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) return null;

    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      return await uploadProfileImage(File(pickedFile.path));
    }
    return null;
  }

  Future<void> updateProfile(
      {String? name, int? age, String? phone, String? password}) async {
    var userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) return;

    Map<String, dynamic> updateData = {
      'name': name,
      'age': age,
      'phone': phone,
    };

    // Remove keys with null values
    updateData.removeWhere((key, value) => value == null);

    await FirebaseFirestore.instance
        .collection('Users')
        .doc(userId)
        .update(updateData);

    if (password != null && password.isNotEmpty) {
      await FirebaseAuth.instance.currentUser?.updatePassword(password);
    }
  }

  Future<void> addDependent(String dependent) async {
    var userDocRef = firestore.collection('Users').doc(auth.currentUser?.uid);
    var userDoc = await userDocRef.get();
    var userData = userDoc.data();
    if (userData != null) {
      List<String> dependents = List<String>.from(userData['dependents'] ?? []);
      dependents.add(dependent);
      await userDocRef.update({'dependents': dependents});
    }
  }

  Future<List<String>> loadDependents() async {
    var userDoc =
        await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    var userData = userDoc.data();
    if (userData != null && userData['dependents'] != null) {
      return List<String>.from(userData['dependents']);
    }
    return [];
  }

  Future<String?> getSelectedDependent() async {
    var userDoc =
        await firestore.collection('Users').doc(auth.currentUser?.uid).get();
    var userData = userDoc.data();
    if (userData != null && userData['selected_dependent'] != null) {
      return userData['selected_dependent'];
    }
    return null;
  }

  Future<void> updateSelectedDependent(String? dependent) async {
    await firestore.collection('Users').doc(auth.currentUser?.uid).update({
      'selected_dependent': dependent,
    });
  }

  Future<Map<String, dynamic>> loadProfileData() async {
    var imageUrl = await getProfileImageUrl();
    var dependents = await loadDependents();
    var selectedDependent = await getSelectedDependent();
    return {
      'profileImageUrl': imageUrl,
      'dependents': dependents,
      'selectedDependent': selectedDependent,
    };
  }

  Future<void> updateUserHealthProfile(Map<String, dynamic> healthData) async {
    await firestore
        .collection('Users')
        .doc(auth.currentUser?.uid)
        .update(healthData);
  }

  // atestado

  Future<List<AtestadoModel>> getAtestadosByUser(String userId) async {
    final snapshot = await firestore
        .collection('Atestados')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => AtestadoModel.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addAtestado(AtestadoModel atestado) async {
    await firestore.collection('Atestados').add(atestado.toMap());
  }

  Future<void> updateAtestado(AtestadoModel atestado) async {
    await firestore
        .collection('Atestados')
        .doc(atestado.id)
        .update(atestado.toMap());
  }

  Future<void> deleteAtestado(String atestadoId) async {
    await firestore.collection('Atestados').doc(atestadoId).delete();
  }

  // vacina

  Future<List<Vacina>> getVacinasByUser(String userId) async {
    final snapshot = await firestore
        .collection('Vacinas')
        .where('userId', isEqualTo: userId)
        .get();

    return snapshot.docs
        .map((doc) => Vacina.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<void> addVacina(Vacina vacina) async {
    await firestore.collection('Vacinas').add(vacina.toMap());
  }

  Future<void> updateVacina(Vacina vacina) async {
    await firestore.collection('Vacinas').doc(vacina.id).update(vacina.toMap());
  }

  Future<void> deleteVacina(String vacinaId) async {
    await firestore.collection('Vacinas').doc(vacinaId).delete();
  }

  // exame

  Future<List<Exame>> fetchExames(String userId) async {
    try {
      final snapshot = await firestore
          .collection('Exames')
          .where('userId', isEqualTo: userId)
          .get();
      return snapshot.docs
          .map((doc) => Exame.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Erro ao buscar exames: $e');
    }
  }

  Future<void> deleteExame(String id) async {
    try {
      await firestore.collection('Exames').doc(id).delete();
    } catch (e) {
      throw Exception('Erro ao deletar exame: $e');
    }
  }
}
