class Exame {
  final String id;
  final String data;
  final String tipo;
  final String userId;

  Exame(
      {required this.id,
      required this.data,
      required this.tipo,
      required this.userId}
  );

  factory Exame.fromMap(Map<String, dynamic> map, String documentId) {
    return Exame(
      id: documentId,
      data: map['data'] ?? '',
      tipo: map['tipo'] ?? '',
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'data': data,
      'tipo': tipo,
      'userId': userId,
    };
  }
}
