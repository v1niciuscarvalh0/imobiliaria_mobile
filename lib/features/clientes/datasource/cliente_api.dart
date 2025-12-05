import '../../../core/network/api_client.dart';
import '../data/models/cliente_model.dart';

class ClienteApi {
  final ApiClient api;

  ClienteApi(this.api);

  Future<List<ClienteModel>> getClientes() async {
    final response = await api.get('/clientes');
    return (response.data as List)
        .map((json) => ClienteModel.fromJson(json))
        .toList();
  }

  Future<ClienteModel> createCliente(ClienteModel cliente) async {
    final response = await api.post('/clientes', cliente.toJson());
    return ClienteModel.fromJson(response.data);
  }

  Future<ClienteModel> updateCliente(ClienteModel cliente) async {
    final response = await api.put('/clientes/${cliente.id}', cliente.toJson());
    return ClienteModel.fromJson(response.data);
  }

  Future<void> deleteCliente(int id) async {
    await api.delete('/clientes/$id');
  }

  Future<List<ClienteModel>> getClientesPaginados(
    int page,
    int limit, {
    String busca = "",
  }) async {
    final query = busca.isEmpty
        ? '/clientes?_page=$page&_limit=$limit'
        : '/clientes?_page=$page&_limit=$limit&q=$busca';

    final response = await api.get(query);

    return (response.data as List)
        .map((json) => ClienteModel.fromJson(json))
        .toList();
  }
}
