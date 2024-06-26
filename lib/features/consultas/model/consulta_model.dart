// models/consulta_model.dart

class ConsultaModel {
  final String id;
  final String date;
  final String areaMedica;
  final String descricao;
  final String userId;
  final String? dependentId;

  ConsultaModel({
    required this.id,
    required this.date,
    required this.areaMedica,
    required this.descricao,
    required this.userId,
    this.dependentId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'date': date,
      'areaMedica': areaMedica,
      'descricao': descricao,
      'userId': userId,
      'dependentId': dependentId,
    };
  }

  static ConsultaModel fromMap(Map<String, dynamic> map, String id) {
    return ConsultaModel(
      id: id,
      date: map['date'],
      areaMedica: map['areaMedica'],
      descricao: map['descricao'],
      userId: map['userId'],
      dependentId: map['dependentId'],
    );
  }
}
