import '../../../../core/network/api_client.dart';
import '../models/imovel_model.dart';

class ImovelApi {
  final ApiClient api;

  ImovelApi(this.api);

  Future<List<ImovelModel>> getImoveis() async {
    final response = await api.get('/imoveis');
    return (response.data as List)
        .map((json) => ImovelModel.fromJson(json))
        .toList();
  }

  Future<ImovelModel> createImovel(ImovelModel i) async {
    final response = await api.post('/imoveis', i.toJson());
    return ImovelModel.fromJson(response.data);
  }

  Future<ImovelModel> updateImovel(ImovelModel i) async {
    final response = await api.put('/imoveis/${i.id}', i.toJson());
    return ImovelModel.fromJson(response.data);
  }

  Future<void> deleteImovel(int id) async {
    await api.delete('/imoveis/$id');
  }

  Future<List<ImovelModel>> getImoveisPaginados(
    int page,
    int limit, {
    String busca = "",
  }) async {
    final query = busca.isEmpty
        ? '/imoveis?_page=$page&_limit=$limit'
        : '/imoveis?_page=$page&_limit=$limit&q=$busca';

    final response = await api.get(query);

    return (response.data as List)
        .map((json) => ImovelModel.fromJson(json))
        .toList();
  }
}
