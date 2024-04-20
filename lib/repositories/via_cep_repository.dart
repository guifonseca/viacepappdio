import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:viacepappdio/model/via_cep_model.dart';

class ViaCepRepository {
  Future<ViaCEPModel> consultarCEP(String cep) async {
    final response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json/"));
    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return ViaCEPModel.fromJson(json);
    }
    return ViaCEPModel();
  }
}
