import 'package:flutter/material.dart';
import '../../data/models/cliente_model.dart';
import '../../datasource/cliente_api.dart';
import '../../data/repository/cliente_repository.dart';
import '../../../../core/network/api_client.dart';

class FormClientePage extends StatefulWidget {
  final ClienteModel? cliente;

  const FormClientePage({this.cliente});

  @override
  _FormClientePageState createState() => _FormClientePageState();
}

class _FormClientePageState extends State<FormClientePage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _loginController = TextEditingController();
  final _senhaController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _dataNascimentoController = TextEditingController();

  late ClienteRepository repository;

  @override
  void initState() {
    super.initState();
    repository = ClienteRepository(ClienteApi(ApiClient()));

    if (widget.cliente != null) {
      _nomeController.text = widget.cliente!.nome ?? '';
      _telefoneController.text = widget.cliente!.telefone ?? '';
      _emailController.text = widget.cliente!.email ?? '';
      _cpfController.text = widget.cliente!.cpf ?? '';
      _loginController.text = widget.cliente!.login ?? '';
      _senhaController.text = widget.cliente!.senha ?? '';
      _enderecoController.text = widget.cliente!.endereco ?? '';
      _dataNascimentoController.text = widget.cliente!.dataNascimento ?? '';
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _telefoneController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _loginController.dispose();
    _senhaController.dispose();
    _enderecoController.dispose();
    _dataNascimentoController.dispose();
    super.dispose();
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final cliente = ClienteModel(
      id: widget.cliente?.id,
      nome: _nomeController.text.trim(),
      telefone: _telefoneController.text.trim(),
      email: _emailController.text.trim(),
      cpf: _cpfController.text.trim(),
      login: _loginController.text.trim(),
      senha: _senhaController.text.trim(),
      endereco: _enderecoController.text.trim().isEmpty
          ? null
          : _enderecoController.text.trim(),
      dataNascimento: _dataNascimentoController.text.trim().isEmpty
          ? null
          : _dataNascimentoController.text.trim(),
    );

    try {
      if (widget.cliente == null) {
        await repository.adicionarCliente(cliente);
      } else {
        await repository.editarCliente(cliente);
      }
      Navigator.pop(context, true);
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Erro ao salvar cliente: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cliente == null ? "Novo Cliente" : "Editar Cliente"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nomeController,
                decoration: InputDecoration(labelText: "Nome"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o nome" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _telefoneController,
                decoration: InputDecoration(labelText: "Telefone"),
                keyboardType: TextInputType.phone,
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o telefone" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(labelText: "Email"),
                keyboardType: TextInputType.emailAddress,
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o email" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _cpfController,
                decoration: InputDecoration(labelText: "CPF"),
                keyboardType: TextInputType.number,
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o CPF" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _loginController,
                decoration: InputDecoration(labelText: "Login"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o login" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _senhaController,
                decoration: InputDecoration(labelText: "Senha"),
                obscureText: true,
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe a senha" : null,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _enderecoController,
                decoration: InputDecoration(labelText: "Endereço"),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _dataNascimentoController,
                decoration: InputDecoration(
                  labelText: "Data de Nascimento (YYYY-MM-DD)",
                ),
              ),
              SizedBox(height: 30),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text("Cancelar"),
                  ),
                  SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: salvar,
                    child: Text(
                      widget.cliente == null ? "Cadastrar" : "Editar",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
