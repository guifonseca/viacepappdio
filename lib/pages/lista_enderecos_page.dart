import 'package:flutter/material.dart';
import 'package:viacepappdio/model/via_cep_back4app_model.dart';
import 'package:viacepappdio/pages/cadastro_endereco_page.dart';
import 'package:viacepappdio/pages/atualizar_endereco_page.dart';
import 'package:viacepappdio/repositories/back4app/viacep_back4app_repository.dart';

class ListaEnderecosPage extends StatefulWidget {
  const ListaEnderecosPage({super.key});

  @override
  State<ListaEnderecosPage> createState() => _ListaEnderecosPageState();
}

class _ListaEnderecosPageState extends State<ListaEnderecosPage> {
  final _viaCepBack4appRepository = ViaCepBack4appRepository();
  var _enderecos = ViaCepBack4appModel(results: []);

  bool loading = false;

  @override
  void initState() {
    super.initState();
    carregarDados();
  }

  void carregarDados() async {
    setState(() {
      loading = true;
    });
    _enderecos = await _viaCepBack4appRepository.listarEnderecos();
    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de Endereços"),
      ),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              itemCount: _enderecos.results.length,
              itemBuilder: (context, index) {
                final endereco = _enderecos.results[index];
                return Card(
                  child: ListTile(
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              AtualizarEnderecoPage(viaCEPModel: endereco),
                        )).then((value) => carregarDados()),
                    isThreeLine: true,
                    title: Text(
                      endereco.cep ?? "",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          endereco.logradouro ?? "",
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        Text("${endereco.localidade} - ${endereco.uf}")
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CadastroEnderecoPage(),
                )).then((value) => carregarDados());
          },
          child: const Icon(Icons.add)),
    );
  }
}
