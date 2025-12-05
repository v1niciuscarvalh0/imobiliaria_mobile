import 'package:flutter/material.dart';
import '../../data/models/imovel_model.dart';
import '../../data/datasource/imovel_api.dart';
import '../../data/repositories/imovel_repository.dart';
import '../../../../core/network/api_client.dart';
import '../../../clientes/data/models/cliente_model.dart';
import '../../../clientes/datasource/cliente_api.dart';
import '../../../clientes/data/repository/cliente_repository.dart';

class FormImovelPage extends StatefulWidget {
  final ImovelModel? imovel;

  const FormImovelPage({this.imovel});

  @override
  _FormImovelPageState createState() => _FormImovelPageState();
}

class _FormImovelPageState extends State<FormImovelPage> {
  final _formKey = GlobalKey<FormState>();

  final _tituloController = TextEditingController();
  final _descController = TextEditingController();
  final _ruaController = TextEditingController();
  final _numeroController = TextEditingController();
  final _complementoController = TextEditingController();
  final _bairroController = TextEditingController();
  final _cidadeController = TextEditingController();
  final _estadoController = TextEditingController();
  final _cepController = TextEditingController();
  final _precoController = TextEditingController();

  late ImovelRepository repository;
  late ClienteRepository clienteRepository;

  List<ClienteModel> clientes = [];
  int? selectedClienteId;

  @override
  void initState() {
    super.initState();
    repository = ImovelRepository(ImovelApi(ApiClient()));
    clienteRepository = ClienteRepository(ClienteApi(ApiClient()));

    _carregarClientes();

    if (widget.imovel != null) {
      _tituloController.text = widget.imovel!.titulo;
      _descController.text = widget.imovel!.descricao;
      _ruaController.text = widget.imovel!.rua;
      _numeroController.text = widget.imovel!.numero ?? '';
      _complementoController.text = widget.imovel!.complemento ?? '';
      _bairroController.text = widget.imovel!.bairro ?? '';
      _cidadeController.text = widget.imovel!.cidade ?? '';
      _estadoController.text = widget.imovel!.estado ?? '';
      _cepController.text = widget.imovel!.cep ?? '';
      _precoController.text = widget.imovel!.preco.toString();
      selectedClienteId = widget.imovel!.proprietarioId;
    }
  }

  Future<void> _carregarClientes() async {
    final list = await clienteRepository.listarClientes();
    setState(() {
      clientes = list;
    });
  }

  @override
  void dispose() {
    _tituloController.dispose();
    _descController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _complementoController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _cepController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  Future<void> salvar() async {
    if (!_formKey.currentState!.validate()) return;

    final imovel = ImovelModel(
      id: widget.imovel?.id,
      titulo: _tituloController.text.trim(),
      descricao: _descController.text.trim(),
      rua: _ruaController.text.trim(),
      numero: _numeroController.text.trim().isEmpty
          ? null
          : _numeroController.text.trim(),
      complemento: _complementoController.text.trim().isEmpty
          ? null
          : _complementoController.text.trim(),
      bairro: _bairroController.text.trim().isEmpty
          ? null
          : _bairroController.text.trim(),
      cidade: _cidadeController.text.trim().isEmpty
          ? null
          : _cidadeController.text.trim(),
      estado: _estadoController.text.trim().isEmpty
          ? null
          : _estadoController.text.trim(),
      cep: _cepController.text.trim().isEmpty
          ? null
          : _cepController.text.trim(),
      preco: double.parse(_precoController.text.trim()),
      proprietarioId: selectedClienteId!,
    );

    if (widget.imovel == null) {
      await repository.adicionarImovel(imovel);
    } else {
      await repository.editarImovel(imovel);
    }

    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.imovel == null ? "Novo Imóvel" : "Editar Imóvel"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _tituloController,
                decoration: InputDecoration(labelText: "Título"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe o título" : null,
              ),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(labelText: "Descrição"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe a descrição" : null,
              ),
              TextFormField(
                controller: _ruaController,
                decoration: InputDecoration(labelText: "Rua"),
                validator: (v) =>
                    v == null || v.isEmpty ? "Informe a rua" : null,
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _numeroController,
                      decoration: InputDecoration(labelText: "Número"),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextFormField(
                      controller: _complementoController,
                      decoration: InputDecoration(labelText: "Complemento"),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _bairroController,
                decoration: InputDecoration(labelText: "Bairro"),
              ),
              TextFormField(
                controller: _cidadeController,
                decoration: InputDecoration(labelText: "Cidade"),
              ),
              TextFormField(
                controller: _estadoController,
                decoration: InputDecoration(labelText: "Estado"),
              ),
              TextFormField(
                controller: _cepController,
                decoration: InputDecoration(labelText: "CEP"),
              ),
              TextFormField(
                controller: _precoController,
                decoration: InputDecoration(labelText: "Preço"),
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.isEmpty) return "Informe o preço";
                  if (double.tryParse(v) == null) return "Preço inválido";
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: selectedClienteId,
                decoration: InputDecoration(labelText: "Proprietário"),
                items: clientes
                    .map(
                      (c) => DropdownMenuItem(
                        value: c.id,
                        child: Text(c.nome ?? ''),
                      ),
                    )
                    .toList(),
                onChanged: (v) => setState(() => selectedClienteId = v),
                validator: (v) => v == null ? "Selecione o proprietário" : null,
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
                    child: Text(widget.imovel == null ? "Cadastrar" : "Editar"),
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
