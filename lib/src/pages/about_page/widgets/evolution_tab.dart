import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/models/specie.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';

class EvolutionTab extends StatelessWidget {
  final PokeApiV2Store _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
  final PokeApiStore _pokeApiStore = GetIt.instance<PokeApiStore>();

  Widget resizePokemon(Widget widget) {
    return SizedBox(
      height: 100,
      width: 100,
      child: widget,
    );
  }

  List<Widget> getEvolucao(Pokemon pokemon) {
    List<Widget> _list = [];
    if (pokemon.prevEvolution != null) {
      pokemon.prevEvolution.forEach((element) {
        _list.add(resizePokemon(_pokeApiStore.getImage(numero: element.num)));
        _list.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              element.name,
              style: TextStyle(
                fontFamily: 'Google',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        _list.add(Icon(Icons.keyboard_arrow_down));
      });
    }
    _list.add(resizePokemon(_pokeApiStore.getImage(numero: pokemon.num)));
    _list.add(
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          pokemon.name,
          style: TextStyle(
            fontFamily: 'Google',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
    if (pokemon.nextEvolution != null) {
      _list.add(Icon(Icons.keyboard_arrow_down));
      pokemon.nextEvolution.forEach((element) {
        _list.add(resizePokemon(_pokeApiStore.getImage(numero: element.num)));
        _list.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              element.name,
              style: TextStyle(
                fontFamily: 'Google',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
        if (pokemon.nextEvolution.last.name != element.name) {
          _list.add(Icon(Icons.keyboard_arrow_down));
        }
      });
    }

    return _list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Observer(builder: (context) {
        Pokemon pokemon = _pokeApiStore.pokemonAtual;
        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: getEvolucao(pokemon),
          ),
        );
      }),
    );
  }
}
