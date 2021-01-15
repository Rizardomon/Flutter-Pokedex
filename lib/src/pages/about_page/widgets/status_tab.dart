import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/models/pokeapiv2.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';

class StatusTab extends StatefulWidget {
  @override
  _StatusTabState createState() => _StatusTabState();
}

class _StatusTabState extends State<StatusTab> {
  final PokeApiV2Store _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();

  List<int> getStatusPokemon(PokeApiV2 pokeApiV2) {
    List<int> list = [1, 2, 3, 4, 5, 6, 7];
    int sum = 0;
    pokeApiV2.stats.forEach((element) {
      sum = sum + element.baseStat;
      switch (element.stat.name) {
        case 'hp':
          list[0] = element.baseStat;
          break;
        case 'attack':
          list[1] = element.baseStat;
          break;
        case 'defense':
          list[2] = element.baseStat;
          break;
        case 'special-attack':
          list[3] = element.baseStat;
          break;
        case 'special-defense':
          list[4] = element.baseStat;
          break;
        case 'speed':
          list[5] = element.baseStat;
          break;
      }
    });
    list[6] = sum;
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'HP',
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 16,
                      color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Attack',
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 16,
                      color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Defense',
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 16,
                      color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Sp. Atk',
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 16,
                      color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Sp. Def',
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 16,
                      color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Speed',
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 16,
                      color: Colors.grey[600]),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Text(
                  'Total',
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 16,
                      color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          SizedBox(
            width: 15,
          ),
          Observer(builder: (context) {
            List<int> _list = getStatusPokemon(_pokeApiV2Store.pokeApiV2);
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _list[0].toString(),
                    style: TextStyle(
                        fontFamily: 'Google',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _list[1].toString(),
                    style: TextStyle(
                        fontFamily: 'Google',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _list[2].toString(),
                    style: TextStyle(
                        fontFamily: 'Google',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _list[3].toString(),
                    style: TextStyle(
                        fontFamily: 'Google',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _list[4].toString(),
                    style: TextStyle(
                        fontFamily: 'Google',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _list[5].toString(),
                    style: TextStyle(
                        fontFamily: 'Google',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Text(
                    _list[6].toString(),
                    style: TextStyle(
                        fontFamily: 'Google',
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }
}
