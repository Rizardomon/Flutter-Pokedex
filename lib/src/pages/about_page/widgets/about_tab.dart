import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/specie.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';
import 'package:provider/single_child_widget.dart';

class AboutTab extends StatelessWidget {
  final PokeApiV2Store _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
  final PokeApiStore _pokeApiStore = GetIt.instance<PokeApiStore>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Description',
            style: TextStyle(
                fontFamily: 'Google',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Observer(builder: (context) {
            Specie _specie = _pokeApiV2Store.specie;
            return SizedBox(
              height: 50,
              child: SingleChildScrollView(
                  child: _specie != null
                      ? Text(
                          _specie.flavorTextEntries
                              .where((item) => item.language.name == 'en')
                              .first
                              .flavorText
                              .replaceAll("\n", " ")
                              .replaceAll("\f", " ")
                              .replaceAll("POKéMON", "Pokémon"),
                          style: TextStyle(
                            fontFamily: 'Google',
                            fontSize: 14,
                          ),
                        )
                      : SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator())),
            );
          }),
          Text(
            'Biology',
            style: TextStyle(
                fontFamily: 'Google',
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 200.0),
            child: Observer(builder: (context) {
              return Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Height',
                        style: TextStyle(
                            fontFamily: 'Google',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Text(
                        _pokeApiStore.pokemonAtual.height,
                        style: TextStyle(
                            fontFamily: 'Google',
                            fontSize: 14,
                            color: Colors.black54),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Weight',
                        style: TextStyle(
                            fontFamily: 'Google',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.black54),
                      ),
                      Text(
                        _pokeApiStore.pokemonAtual.weight,
                        style: TextStyle(
                            fontFamily: 'Google',
                            fontSize: 14,
                            color: Colors.black54),
                      ),
                    ],
                  )
                ],
              );
            }),
          )
        ],
      ),
    );
  }
}
