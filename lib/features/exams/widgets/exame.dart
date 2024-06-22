class Exame {
  final String id;
  final String date;
  final String tipo;
  final String userId;
  final String laudo;
  final String? arquivoUrl;
  final String? dependentId;

  Exame({
    required this.id,
    required this.date,
    required this.tipo,
    required this.laudo,
    required this.userId,
    this.arquivoUrl,
    required this.dependentId,
  });

  factory Exame.fromMap(Map<String, dynamic> map, String documentId) {
    return Exame(
      id: documentId,
      date: map['data'] ?? '',
      tipo: map['tipo'] ?? '',
      laudo: map['laudo'] ?? '',
      userId: map['userId'] ?? '',
      arquivoUrl: map['arquivoUrl'],
      dependentId: map['dependentId'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'tipo': tipo,
      'laudo': laudo,
      'data': date,
      'userId': userId,
      'dependentId': dependentId,
    };

    if (arquivoUrl != null) {
      data['arquivoUrl'] =
          arquivoUrl; // Adiciona a URL do arquivo se não for nulo
    }

    return data;
  }
}
