import '../../datasource/cliente_api.dart';
import '../models/cliente_model.dart';

class ClienteRepository {
  final ClienteApi api;

  ClienteRepository(this.api);

  Future<List<ClienteModel>> listarClientes() => api.getClientes();

  Future<ClienteModel> adicionarCliente(ClienteModel c) => api.createCliente(c);

  Future<ClienteModel> editarCliente(ClienteModel c) => api.updateCliente(c);

  Future<void> excluirCliente(int id) => api.deleteCliente(id);

  Future<List<ClienteModel>> listarClientesPaginados(
    int page,
    int limit, {
    String busca = "",
  }) {
    return api.getClientesPaginados(page, limit, busca: busca);
  }
}
