// lib/models/user_model.dart
class UserModel {
  String id;
  String name;
  String email;
  String phone;
  int age;
  String? profilePictureUrl;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.age,
    this.profilePictureUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data, String documentId) {
    return UserModel(
      id: documentId,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      age: data['age'],
      profilePictureUrl: data['profile_picture'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'age': age,
      'profile_picture': profilePictureUrl,
    };
  }
}
