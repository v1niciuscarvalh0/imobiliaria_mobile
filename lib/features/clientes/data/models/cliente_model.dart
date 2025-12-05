class ClienteModel {
  final int? id;
  final String? cpf;
  final String? email;
  final String? login;
  final String? nome;
  final String? senha;
  final String? telefone;
  final String? endereco;
  final String? dataNascimento; // YYYY-MM-DD

  ClienteModel({
    this.id,
    this.cpf,
    this.email,
    this.login,
    this.nome,
    this.senha,
    this.telefone,
    this.endereco,
    this.dataNascimento,
  });

  factory ClienteModel.fromJson(Map<String, dynamic> json) => ClienteModel(
    id: json['id'],
    cpf: json['cpf']?.toString(),
    email: json['email']?.toString(),
    login: json['login']?.toString(),
    nome: json['nome']?.toString(),
    senha: json['senha']?.toString(),
    telefone: json['telefone']?.toString(),
    endereco: json['endereco']?.toString(),
    dataNascimento: json['data_nascimento']?.toString(),
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'cpf': cpf,
    'email': email,
    'login': login,
    'nome': nome,
    'senha': senha,
    'telefone': telefone,
    'endereco': endereco,
    'data_nascimento': dataNascimento,
  };

  Map<String, dynamic> toJsonForUpdate() => {
    'cpf': cpf,
    'email': email,
    'login': login,
    'nome': nome,
    'senha': senha,
    'telefone': telefone,
    'endereco': endereco,
    'data_nascimento': dataNascimento,
  };
}
