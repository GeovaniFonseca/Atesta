class Atestado {
  final String id;
  final String nomeMedico;
  final String dataEmissao;
  final int quantidadeDias;
  final String? arquivoUrl;
  final String userId;

  Atestado({
    required this.id,
    required this.nomeMedico,
    required this.dataEmissao,
    required this.quantidadeDias,
    this.arquivoUrl,
    required this.userId,
  });

  factory Atestado.fromMap(Map<String, dynamic> map, String documentId) {
    return Atestado(
      id: documentId,
      nomeMedico: map['nomeMedico'] ?? '',
      dataEmissao: map['dataEmissao'] ?? '',
      quantidadeDias: map['quantidadeDias'] ?? 0,
      arquivoUrl: map['arquivoUrl'],
      userId: map['userId'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = {
      'nomeMedico': nomeMedico,
      'dataEmissao': dataEmissao,
      'quantidadeDias': quantidadeDias,
      'userId': userId,
    };

    if (arquivoUrl != null) {
      data['arquivoUrl'] =
          arquivoUrl; // Adiciona a URL do arquivo se não for nulo
    }

    return data;
  }
}
