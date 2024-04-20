import 'package:flutter/material.dart';
import 'package:viacepappdio/model/via_cep_model.dart';
import 'package:viacepappdio/repositories/back4app/viacep_back4app_repository.dart';

class AtualizarEnderecoPage extends StatefulWidget {
  final ViaCEPModel viaCEPModel;

  const AtualizarEnderecoPage({super.key, required this.viaCEPModel});

  @override
  State<AtualizarEnderecoPage> createState() => _AtualizarEnderecoPageState();
}

class _AtualizarEnderecoPageState extends State<AtualizarEnderecoPage> {
  final viaCepBack4appRepository = ViaCepBack4appRepository();

  final cepController = TextEditingController(text: "");
  final logradouroController = TextEditingController(text: "");
  final complementoController = TextEditingController(text: "");
  final bairroController = TextEditingController(text: "");
  final localidadeController = TextEditingController(text: "");
  final ufController = TextEditingController(text: "");
  final ibgeController = TextEditingController(text: "");
  final giaController = TextEditingController(text: "");
  final dddController = TextEditingController(text: "");
  final siafiController = TextEditingController(text: "");

  @override
  void initState() {
    super.initState();
    cepController.text = widget.viaCEPModel.cep ?? "";
    logradouroController.text = widget.viaCEPModel.logradouro ?? "";
    complementoController.text = widget.viaCEPModel.complemento ?? "";
    bairroController.text = widget.viaCEPModel.bairro ?? "";
    localidadeController.text = widget.viaCEPModel.localidade ?? "";
    ufController.text = widget.viaCEPModel.uf ?? "";
    ibgeController.text = widget.viaCEPModel.ibge ?? "";
    giaController.text = widget.viaCEPModel.gia ?? "";
    dddController.text = widget.viaCEPModel.ddd ?? "";
    siafiController.text = widget.viaCEPModel.siafi ?? "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Atualizar Endereço"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (bc) => AlertDialog(
                      title: const Text("Exclusão"),
                      actions: [
                        OutlinedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text("Cancelar")),
                        ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(bc);
                              await viaCepBack4appRepository
                                  .removerEndereco(widget.viaCEPModel.objectId!)
                                  .then((value) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        backgroundColor: Colors.green,
                                        content: Text(
                                            "Exclusão realizada com sucesso")));
                                Navigator.pop(context);
                              });
                            },
                            child: const Text("Excluir"))
                      ],
                      content: const Text(
                        "Deseja continuar com a exclusão do registro?",
                        style: TextStyle(fontSize: 16),
                      )),
                );
              },
            ),
          )
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          TextField(
            enabled: false,
            decoration: const InputDecoration(label: Text("CEP")),
            controller: cepController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("Logradouro")),
            controller: logradouroController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("Complemento")),
            controller: complementoController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("Bairro")),
            controller: bairroController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("Localidade")),
            controller: localidadeController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("UF")),
            maxLength: 2,
            controller: ufController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("IBGE")),
            controller: ibgeController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("GIA")),
            controller: giaController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("DDD")),
            maxLength: 2,
            keyboardType: TextInputType.number,
            controller: dddController,
          ),
          const SizedBox(
            height: 15,
          ),
          TextField(
            decoration: const InputDecoration(label: Text("SIAFI")),
            controller: siafiController,
          ),
          const SizedBox(
            height: 25,
          ),
          ElevatedButton(
              onPressed: () async {
                FocusManager.instance.primaryFocus?.unfocus();
                await viaCepBack4appRepository
                    .atualizarEndereco(ViaCEPModel(
                        objectId: widget.viaCEPModel.objectId,
                        bairro: bairroController.text,
                        cep: cepController.text,
                        complemento: complementoController.text,
                        ddd: dddController.text,
                        gia: giaController.text,
                        ibge: ibgeController.text,
                        localidade: localidadeController.text,
                        logradouro: logradouroController.text,
                        siafi: siafiController.text,
                        uf: ufController.text))
                    .then((value) => ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            backgroundColor: Colors.green,
                            content: Text("Dados atualizados com sucesso"))))
                    .onError((error, stackTrace) => ScaffoldMessenger.of(
                            context)
                        .showSnackBar(const SnackBar(
                            backgroundColor: Colors.red,
                            content: Text(
                                "Ocorreu um erro durante a atualização dos dados"))));
              },
              child: const Text("Salvar"))
        ],
      ),
    );
  }
}
