import 'package:audioplayers/audioplayers.dart';
import 'package:fausto/bloc/flutter_tts/flutter_tts_bloc.dart';
import 'package:fausto/dependencies/get_it.dart';
import 'package:fausto/model/jogo_model.dart';
import 'package:fausto/services/jogo_service.dart';
import 'package:fausto/utils/cores.dart';
import 'package:flutter/material.dart';

class DiasDaSemana extends StatefulWidget {
  const DiasDaSemana({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DiasDaSemanaState createState() => _DiasDaSemanaState();
}

class _DiasDaSemanaState extends State<DiasDaSemana> {
  final player = AudioPlayer();
  late List<SemanaModel> diasList = [];
  int? elementoSelecionado;

  @override
  void initState() {
    super.initState();
    loadAllData();
  }

  Future<void> loadAllData() async {
    try {
      // Carregar lista de alfabeto
      List<SemanaModel> loadedSemana = await JogoService.getAllDiasDaSemana();
      setState(() {
        diasList = loadedSemana;
      });
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao carregar dias da Semana"),
          backgroundColor: Colors.black,
        ),
      );
      setState(() {
        diasList = [];
      });
    }
  }

  void changeColor(int id) {
    setState(() {
      if (elementoSelecionado == id) {
        elementoSelecionado = null;
      } else {
        elementoSelecionado = id;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: corSegundaria,
              elevation: 0,
              toolbarHeight: 40,
            ),
            body: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: GridView.count(
                primary: false,
                padding: const EdgeInsets.only(right: 10, left: 10, top: 20),
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                crossAxisCount: 2,
                scrollDirection: Axis.vertical,
                childAspectRatio: 1,
                children: <Widget>[
                  for (SemanaModel dia in diasList)
                    InkWell(
                      onTap: () {
                        // player.play(AssetSource(dia.audio));
                        getIt<FlutterTtsBloc>().add(FlutterTtsEventSpeak(dia.nome));
                        changeColor(dia.id);
                      },
                      child: Container(
                          width: double.maxFinite / 2 - 100,
                          height: 150,
                          decoration: BoxDecoration(
                            color: elementoSelecionado == dia.id
                                ? corSegundaria
                                : corPrincipal,
                            border: Border.all(width: 5, color: corSegundaria),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                height: 120,
                                child: Image.asset(dia.imagem),
                              ),
                              Text(
                                dia.nome,
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          )),
                    ),
                ],
              ),
            )));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }
}
