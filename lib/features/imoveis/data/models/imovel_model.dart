class ImovelModel {
  final int? id;
  final String titulo;
  final String descricao;
  final String rua;
  final String? numero;
  final String? complemento;
  final String? bairro;
  final String? cidade;
  final String? estado;
  final String? cep;
  final double preco;
  final int proprietarioId;

  ImovelModel({
    this.id,
    required this.titulo,
    required this.descricao,
    required this.rua,
    this.numero,
    this.complemento,
    this.bairro,
    this.cidade,
    this.estado,
    this.cep,
    required this.preco,
    required this.proprietarioId,
  });

  factory ImovelModel.fromJson(Map<String, dynamic> json) {
    return ImovelModel(
      id: json['id'],
      titulo: json['titulo'] ?? '',
      descricao: json['descricao'] ?? '',
      rua: json['rua'] ?? '',
      numero: json['numero'],
      complemento: json['complemento'],
      bairro: json['bairro'],
      cidade: json['cidade'],
      estado: json['estado'],
      cep: json['cep'],
      preco: (json['preco'] != null) ? (json['preco'] as num).toDouble() : 0.0,
      proprietarioId: json['proprietario'] != null
          ? json['proprietario']['id'] ?? 0
          : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'titulo': titulo,
      'descricao': descricao,
      'rua': rua,
      'numero': numero,
      'complemento': complemento,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'cep': cep,
      'preco': preco,
      'proprietario': {'id': proprietarioId},
    };
  }
}
