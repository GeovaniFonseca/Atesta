// lib/viewmodels/profile_viewmodel.dart
import 'package:flutter/material.dart';

import '../../../services/database_service.dart';

class ProfileViewModel extends ChangeNotifier {
  final DatabaseService _databaseService = DatabaseService();
  String? _profileImageUrl;
  String? _selectedDependent;
  List<String> _dependents = [];

  String? get profileImageUrl => _profileImageUrl;
  String? get selectedDependent => _selectedDependent;
  List<String> get dependents => _dependents;

  Future<void> loadProfileData() async {
    var profileData = await _databaseService.loadProfileData();
    _profileImageUrl = profileData['profileImageUrl'];
    _dependents = List<String>.from(profileData['dependents']);
    _selectedDependent = profileData['selectedDependent'];
    notifyListeners();
  }

  Future<void> updateProfilePicture(BuildContext context) async {
    var imageUrl = await _databaseService.updateProfilePicture(context);
    if (imageUrl != null) {
      _profileImageUrl = imageUrl;
      notifyListeners();
    }
  }

  Future<void> addDependent(String dependentName) async {
    await _databaseService.addDependent(dependentName);
    await loadProfileData();
  }

  Future<void> updateSelectedDependent(String? dependent) async {
    await _databaseService.updateSelectedDependent(dependent);
    _selectedDependent = dependent;
    notifyListeners();
  }
}
