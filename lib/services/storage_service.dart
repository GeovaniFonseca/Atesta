import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class StorageService {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<String?> uploadFile(File file) async {
    // Modificado para aceitar um File
    try {
      String fileName = file.path
          .split('/')
          .last; // Obtém o nome do arquivo baseado no caminho
      TaskSnapshot uploadTask =
          await storage.ref('exames/$fileName').putFile(file);

      // Retorna a URL do arquivo após o upload
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return null;
    }
  }
}
