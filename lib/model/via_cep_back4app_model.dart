import 'package:viacepappdio/model/via_cep_model.dart';

class ViaCepBack4appModel {
  List<ViaCEPModel> results = [];

  ViaCepBack4appModel({required this.results});

  ViaCepBack4appModel.fromJson(Map<String, dynamic> json) {
    if (json['results'] != null) {
      results = <ViaCEPModel>[];
      json['results'].forEach((v) {
        results.add(ViaCEPModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['results'] = results.map((v) => v.toJson()).toList();
    return data;
  }
}
