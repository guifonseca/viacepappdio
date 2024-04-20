import 'package:viacepappdio/model/via_cep_back4app_model.dart';
import 'package:viacepappdio/model/via_cep_model.dart';
import 'package:viacepappdio/repositories/back4app/back4app_custom_dio.dart';

class ViaCepBack4appRepository {
  final _customDio = Back4appCustomDio();

  Future<ViaCepBack4appModel> listarEnderecos() async {
    final result = await _customDio.dio.get("/ViaCEP");
    return ViaCepBack4appModel.fromJson(result.data);
  }

  Future<ViaCepBack4appModel> buscarEnderecoPorCEP(String cep) async {
    String queryParams = "?where={\"cep\":\"$cep\"}";
    final result = await _customDio.dio.get("/ViaCEP$queryParams");
    return ViaCepBack4appModel.fromJson(result.data);
  }

  Future<void> criarEndereco(ViaCEPModel viaCEPModel) async {
    try {
      await _customDio.dio.post("/ViaCEP", data: viaCEPModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> atualizarEndereco(ViaCEPModel viaCEPModel) async {
    try {
      await _customDio.dio
          .put("/ViaCEP/${viaCEPModel.objectId}", data: viaCEPModel.toJson());
    } catch (e) {
      rethrow;
    }
  }

  Future<void> removerEndereco(String objectId) async {
    try {
      await _customDio.dio.delete("/ViaCEP/$objectId");
    } catch (e) {
      rethrow;
    }
  }
}
