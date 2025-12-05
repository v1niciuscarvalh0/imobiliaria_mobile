import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/cliente_model.dart';
import '../../datasource/cliente_api.dart';
import '../../data/repository/cliente_repository.dart';
import '../../../../core/network/api_client.dart';
import 'form_cliente_page.dart';

class PaginaClientes extends StatefulWidget {
  @override
  _PaginaClientesState createState() => _PaginaClientesState();
}

class _PaginaClientesState extends State<PaginaClientes> {
  late ClienteRepository repository;

  List<ClienteModel> clientes = [];
  bool isLoading = false; // indica carregamento geral
  bool hasMore = true;

  int page = 1;
  final int limit = 20;

  String busca = "";
  Timer? debounce;

  final ScrollController scrollController = ScrollController();
  final TextEditingController buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    repository = ClienteRepository(ClienteApi(ApiClient()));
    carregarMais();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent * 0.9) {
        carregarMais();
      }
    });
  }

  @override
  void dispose() {
    debounce?.cancel();
    scrollController.dispose();
    buscaController.dispose();
    super.dispose();
  }

  Future<void> carregarMais() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    final novos = await repository.listarClientesPaginados(
      page,
      limit,
      busca: busca,
    );

    setState(() {
      page++;
      clientes.addAll(novos);
      if (novos.length < limit) hasMore = false;
      isLoading = false;
    });
  }

  Future<void> atualizarLista() async {
    setState(() {
      page = 1;
      clientes.clear();
      hasMore = true;
      isLoading = true;
    });
    await carregarMais();
    setState(() => isLoading = false);
  }

  void onSearchChanged(String texto) {
    if (debounce?.isActive ?? false) debounce!.cancel();

    debounce = Timer(Duration(milliseconds: 300), () {
      setState(() {
        busca = texto;
      });
      atualizarLista();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Clientes')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FormClientePage()),
          );

          if (updated == true) atualizarLista();
        },
      ),
      body: Column(
        children: [
          // 🔍 Campo de busca
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: buscaController,
              decoration: InputDecoration(
                labelText: "Buscar cliente...",
                prefixIcon: Icon(Icons.search),
                suffixIcon: busca.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () {
                          buscaController.clear();
                          busca = "";
                          atualizarLista();
                        },
                      )
                    : null,
              ),
              onChanged: onSearchChanged,
            ),
          ),

          // Lista ou loading inicial
          Expanded(
            child: isLoading && clientes.isEmpty
                ? Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: atualizarLista,
                    child: ListView.builder(
                      controller: scrollController,
                      itemCount: clientes.length + (hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == clientes.length) {
                          // loading no final da lista (paginação)
                          return Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }

                        final c = clientes[index];

                        return Card(
                          child: ListTile(
                            title: Text(c.nome ?? 'Sem nome'),
                            subtitle: Text(c.telefone ?? 'Sem telefone'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  onPressed: () async {
                                    final updated = await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) =>
                                            FormClientePage(cliente: c),
                                      ),
                                    );
                                    if (updated == true) atualizarLista();
                                  },
                                  icon: Icon(Icons.edit, color: Colors.blue),
                                ),
                                IconButton(
                                  onPressed: () async {
                                    setState(() => isLoading = true);
                                    await repository.excluirCliente(c.id!);
                                    await atualizarLista();
                                    setState(() => isLoading = false);
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
