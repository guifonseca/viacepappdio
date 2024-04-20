import 'package:flutter/material.dart';
import 'package:viacepappdio/model/via_cep_back4app_model.dart';
import 'package:viacepappdio/model/via_cep_model.dart';
import 'package:viacepappdio/pages/atualizar_endereco_page.dart';
import 'package:viacepappdio/repositories/back4app/viacep_back4app_repository.dart';
import 'package:viacepappdio/repositories/via_cep_repository.dart';

class CadastroEnderecoPage extends StatefulWidget {
  const CadastroEnderecoPage({super.key});

  @override
  State<CadastroEnderecoPage> createState() => _CadastroEnderecoPageState();
}

class _CadastroEnderecoPageState extends State<CadastroEnderecoPage> {
  final cepController = TextEditingController(text: "");
  final viaCepRepository = ViaCepRepository();
  final viaCepBack4appRepository = ViaCepBack4appRepository();

  ViaCepBack4appModel? _viaCepBack4appModel;
  ViaCEPModel viaCEPModel = ViaCEPModel();
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Via CEP"),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  children: [
                    const Text(
                      "Consulta CEP",
                      style: TextStyle(fontSize: 22),
                    ),
                    TextField(
                      controller: cepController,
                      autofocus: true,
                      keyboardType: TextInputType.number,
                      maxLength: 8,
                      onChanged: (value) async {
                        final cep =
                            value.trim().replaceAll(RegExp(r'[^0-9]'), '');
                        if (cep.length == 8) {
                          setState(() {
                            loading = true;
                          });
                          _viaCepBack4appModel = await viaCepBack4appRepository
                              .buscarEnderecoPorCEP(cep);
                          viaCEPModel =
                              await viaCepRepository.consultarCEP(cep);
                        }
                        setState(() {
                          loading = false;
                        });
                      },
                    ),
                    Visibility(
                      visible: _viaCepBack4appModel != null &&
                          _viaCepBack4appModel!.results.isEmpty,
                      child: const SizedBox(
                        height: 30,
                      ),
                    ),
                    Visibility(
                      visible: _viaCepBack4appModel != null &&
                          _viaCepBack4appModel!.results.isEmpty,
                      child: Text(viaCEPModel.logradouro ?? "",
                          style: const TextStyle(fontSize: 22)),
                    ),
                    Visibility(
                      visible: _viaCepBack4appModel != null &&
                          _viaCepBack4appModel!.results.isEmpty,
                      child: Text(
                          "${viaCEPModel.localidade ?? ""} - ${viaCEPModel.uf ?? ""}",
                          style: const TextStyle(fontSize: 22)),
                    ),
                    Visibility(
                        visible: loading,
                        child: const CircularProgressIndicator()),
                    const SizedBox(
                      height: 30,
                    ),
                    Visibility(
                        visible: _viaCepBack4appModel != null &&
                            _viaCepBack4appModel!.results.isNotEmpty,
                        child: const Text(
                          "O CEP informado já encontra-se cadastrado",
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        )),
                    const SizedBox(
                      height: 10,
                    ),
                    (_viaCepBack4appModel?.results ?? []).isNotEmpty
                        ? ElevatedButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              if (_viaCepBack4appModel != null &&
                                  _viaCepBack4appModel!.results.isNotEmpty) {
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          AtualizarEnderecoPage(
                                              viaCEPModel: _viaCepBack4appModel!
                                                  .results[0]),
                                    ));
                              }
                            },
                            child: const Text("Editar"))
                        : ElevatedButton(
                            onPressed: () async {
                              FocusManager.instance.primaryFocus?.unfocus();
                              await viaCepBack4appRepository
                                  .criarEndereco(viaCEPModel)
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                            "Endereço cadastrado com sucesso")));
                                Navigator.pop(context);
                              });
                            },
                            child: const Text("Salvar"))
                  ],
                )),
          ),
        ));
  }
}
