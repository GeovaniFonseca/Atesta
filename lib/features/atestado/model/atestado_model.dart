// lib/models/atestado_model.dart
class AtestadoModel {
  String id;
  String userId;
  String nomeMedico;
  int quantidadeDias;
  String dataEmissao;
  String? arquivoUrl;
  String? dependentId;

  AtestadoModel({
    required this.id,
    required this.userId,
    required this.nomeMedico,
    required this.quantidadeDias,
    required this.dataEmissao,
    this.arquivoUrl,
    this.dependentId,
  });

  factory AtestadoModel.fromMap(Map<String, dynamic> data, String documentId) {
    return AtestadoModel(
      id: documentId,
      userId: data['userId'],
      nomeMedico: data['nomeMedico'],
      quantidadeDias: data['quantidadeDias'],
      dataEmissao: data['dataEmissao'],
      arquivoUrl: data['arquivoUrl'],
      dependentId: data['dependentId'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'nomeMedico': nomeMedico,
      'quantidadeDias': quantidadeDias,
      'dataEmissao': dataEmissao,
      'arquivoUrl': arquivoUrl,
      'dependentId': dependentId,
    };
  }
}
