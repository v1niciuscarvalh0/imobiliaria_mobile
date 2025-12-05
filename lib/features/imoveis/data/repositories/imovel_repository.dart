import '../datasource/imovel_api.dart';
import '../models/imovel_model.dart';

class ImovelRepository {
  final ImovelApi api;

  ImovelRepository(this.api);

  Future<List<ImovelModel>> listarImoveis() => api.getImoveis();

  Future<ImovelModel> adicionarImovel(ImovelModel i) => api.createImovel(i);

  Future<ImovelModel> editarImovel(ImovelModel i) => api.updateImovel(i);

  Future<void> excluirImovel(int id) => api.deleteImovel(id);

  Future<List<ImovelModel>> listarImoveisPaginados(
    int page,
    int limit, {
    String busca = "",
  }) {
    return api.getImoveisPaginados(page, limit, busca: busca);
  }
}
