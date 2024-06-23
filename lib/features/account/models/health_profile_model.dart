// lib/models/health_profile_model.dart
class HealthProfileModel {
  String? bloodType;
  String? bloodDonor;
  String? organDonor;
  String? exercises;
  String? weight;
  String? height;

  HealthProfileModel({
    this.bloodType,
    this.bloodDonor,
    this.organDonor,
    this.exercises,
    this.weight,
    this.height,
  });

  factory HealthProfileModel.fromMap(Map<String, dynamic> data) {
    return HealthProfileModel(
      bloodType: data['bloodType'],
      bloodDonor: data['bloodDonor'],
      organDonor: data['organDonor'],
      exercises: data['exercises'],
      weight: data['weight'],
      height: data['height'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'bloodType': bloodType,
      'bloodDonor': bloodDonor,
      'organDonor': organDonor,
      'exercises': exercises,
      'weight': weight,
      'height': height,
    };
  }
}
