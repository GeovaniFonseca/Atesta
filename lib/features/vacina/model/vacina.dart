class Vacina {
  final String id;
  final String dateAplicacao;
  final String? dateReforco;
  final String tipo;
  final String userId;
  final String? numeroLote;
  final String? efeitosColaterais;
  final String? arquivoUrl;
  final String? dependentId;

  Vacina({
    required this.id,
    required this.dateAplicacao,
    this.dateReforco,
    required this.tipo,
    required this.userId,
    this.numeroLote,
    this.efeitosColaterais,
    this.arquivoUrl,
    this.dependentId,
  });

  factory Vacina.fromMap(Map<String, dynamic> map, String documentId) {
    return Vacina(
      id: documentId,
      dateAplicacao: map['dateAplicacao'] ?? '',
      dateReforco: map['dateReforco'],
      tipo: map['tipo'] ?? '',
      userId: map['userId'] ?? '',
      numeroLote: map['numeroLote'],
      efeitosColaterais: map['efeitosColaterais'],
      arquivoUrl: map['arquivoUrl'],
      dependentId: map['dependentId'],
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'dateAplicacao': dateAplicacao,
      'dateReforco': dateReforco,
      'tipo': tipo,
      'userId': userId,
      'numeroLote': numeroLote,
      'efeitosColaterais': efeitosColaterais,
      'dependentId': dependentId,
    };

    if (arquivoUrl != null) {
      data['arquivoUrl'] = arquivoUrl;
    }

    return data;
  }
}
