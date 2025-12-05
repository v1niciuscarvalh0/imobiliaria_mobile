import 'dart:async';
import 'package:flutter/material.dart';
import '../../data/models/imovel_model.dart';
import '../../data/datasource/imovel_api.dart';
import '../../data/repositories/imovel_repository.dart';
import '../../../../core/network/api_client.dart';
import 'form_imovel_page.dart';

class PaginaImoveis extends StatefulWidget {
  @override
  _PaginaImoveisState createState() => _PaginaImoveisState();
}

class _PaginaImoveisState extends State<PaginaImoveis> {
  late ImovelRepository repository;

  List<ImovelModel> imoveis = [];
  bool isLoading = false;
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
    repository = ImovelRepository(ImovelApi(ApiClient()));
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
    super.dispose();
  }

  Future<void> carregarMais() async {
    if (isLoading || !hasMore) return;

    setState(() => isLoading = true);

    final novos = await repository.listarImoveisPaginados(
      page,
      limit,
      busca: busca,
    );

    setState(() {
      page++;
      imoveis.addAll(novos);
      if (novos.length < limit) hasMore = false;
      isLoading = false;
    });
  }

  Future<void> atualizarLista() async {
    setState(() {
      page = 1;
      imoveis.clear();
      hasMore = true;
    });
    await carregarMais();
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
      appBar: AppBar(title: Text('Imóveis')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add_home_outlined),
        onPressed: () async {
          final updated = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => FormImovelPage()),
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
                labelText: "Buscar imóvel...",
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

          Expanded(
            child: RefreshIndicator(
              onRefresh: atualizarLista,
              child: ListView.builder(
                controller: scrollController,
                itemCount: imoveis.length + 1,
                itemBuilder: (context, index) {
                  if (index == imoveis.length) {
                    return hasMore
                        ? Padding(
                            padding: const EdgeInsets.all(16),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        : SizedBox();
                  }

                  final i = imoveis[index];

                  return Card(
                    child: ListTile(
                      title: Text(i.titulo),
                      subtitle: Text(
                        "Preço: R\$ ${i.preco.toStringAsFixed(2)}",
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              final updated = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FormImovelPage(imovel: i),
                                ),
                              );
                              if (updated == true) atualizarLista();
                            },
                            icon: Icon(Icons.edit, color: Colors.blue),
                          ),
                          IconButton(
                            onPressed: () async {
                              await repository.excluirImovel(i.id!);
                              atualizarLista();
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
