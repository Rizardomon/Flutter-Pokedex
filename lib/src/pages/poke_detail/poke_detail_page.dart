import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:pokedex/consts/consts_app.dart';
import 'package:pokedex/models/pokeapi.dart';
import 'package:pokedex/src/pages/about_page/about_page.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:sliding_sheet/sliding_sheet.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';

class PokeDetailPage extends StatefulWidget {
  final int index;
  final String name;

  PokeDetailPage({Key key, this.index, this.name}) : super(key: key);

  @override
  _PokeDetailPageState createState() => _PokeDetailPageState();
}

class _PokeDetailPageState extends State<PokeDetailPage> {
  PageController _pageController;
  Pokemon _pokemon;
  PokeApiStore _pokemonStore;
  MultiTrackTween _animation;
  double _progress;
  double _multiple;
  double _opacity;
  double _opacityTitleAppBar;
  PokeApiV2Store _pokeApiV2Store;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: widget.index);
    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
    _pokeApiV2Store.getInfoPokemon(_pokemonStore.pokemonAtual.name);
    _pokeApiV2Store.getInfoSpecie(_pokemonStore.pokemonAtual.id.toString());
    _pokemon = _pokemonStore.pokemonAtual;
    _animation = MultiTrackTween([
      Track("rotation").add(Duration(seconds: 5), Tween(begin: 0.0, end: 6.0),
          curve: Curves.linear)
    ]);
    _progress = 0;
    _multiple = 1;
    _opacity = 1;
    _opacityTitleAppBar = 0;
  }

  double interval(double lower, double upper, double progress) {
    assert(lower < upper);

    if (progress > upper) return 1.0;
    if (progress < lower) return 0.0;

    return ((progress - lower) / (upper - lower)).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (BuildContext context) {
      return Scaffold(
        body: Stack(
          children: [
            Observer(builder: (context) {
              return AnimatedContainer(
                duration: Duration(milliseconds: 300),
                color: _pokemonStore.corPokemon,
                child: Stack(
                  children: [
                    AppBar(
                      title: Opacity(
                        opacity: _opacityTitleAppBar,
                      ),
                      centerTitle: true,
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                          icon: Icon(Icons.arrow_back),
                          onPressed: () {
                            Navigator.pop(context);
                          }),
                      actions: [
                        IconButton(
                            icon: Icon(Icons.favorite_border), onPressed: () {})
                      ],
                    ),
                    Positioned(
                        top: MediaQuery.of(context).size.height * 0.1 -
                            _progress *
                                (MediaQuery.of(context).size.height * 0.035),
                        left: 20 +
                            _progress *
                                (MediaQuery.of(context).size.height * 0.090),
                        child: Text(_pokemonStore.pokemonAtual.name,
                            style: TextStyle(
                                fontFamily: 'Google',
                                fontSize: 34 -
                                    _progress *
                                        (MediaQuery.of(context).size.height *
                                            0.011),
                                fontWeight: FontWeight.bold,
                                color: Colors.white))),
                    Positioned(
                      top: MediaQuery.of(context).size.height * 0.14,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              setTipos(_pokemonStore.pokemonAtual.type),
                              Text('#' + _pokemonStore.pokemonAtual.num,
                                  style: TextStyle(
                                      fontFamily: 'Google',
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              );
            }),
            Container(
              height: MediaQuery.of(context).size.height,
            ),
            SlidingSheet(
              listener: (state) {
                setState(() {
                  _progress = state.progress;
                  _multiple = 1 - interval(0.0, 0.90, _progress);
                  _opacity = _multiple;
                  _opacityTitleAppBar =
                      _multiple = interval(0.0, 0.90, _progress);
                });
              },
              cornerRadius: 30,
              snapSpec: const SnapSpec(
                snap: true,
                snappings: [0.6, 0.889],
                positioning: SnapPositioning.relativeToAvailableSpace,
              ),
              builder: (context, state) {
                return Container(
                  height: MediaQuery.of(context).size.height -
                      MediaQuery.of(context).size.height * 0.12,
                  child: AboutPage(),
                );
              },
            ),
            Opacity(
              opacity: _opacity,
              child: Padding(
                  padding: EdgeInsets.only(
                      top: _opacityTitleAppBar == 1
                          ? 1000
                          : (MediaQuery.of(context).size.height * 0.2) -
                              _progress * 60),
                  child: SizedBox(
                    height: 200,
                    child: PageView.builder(
                        controller: _pageController,
                        onPageChanged: (index) {
                          _pokemonStore.setPokemonAtual(index: index);
                          _pokeApiV2Store
                              .getInfoPokemon(_pokemonStore.pokemonAtual.name);
                          _pokeApiV2Store.getInfoSpecie(
                              _pokemonStore.pokemonAtual.id.toString());
                        },
                        itemCount: _pokemonStore.pokeAPI.pokemon.length,
                        itemBuilder: (BuildContext context, int index) {
                          Pokemon _pokeItem =
                              _pokemonStore.getPokemon(index: index);
                          return Stack(
                            alignment: Alignment.center,
                            children: [
                              ControlledAnimation(
                                playback: Playback.LOOP,
                                duration: _animation.duration,
                                tween: _animation,
                                builder: (context, animation) {
                                  return Transform.rotate(
                                    angle: animation['rotation'],
                                    child: Hero(
                                      tag: index.toString(),
                                      child: Opacity(
                                        child: Image.asset(
                                          ConstsApp.whitePokeball,
                                          height: 270,
                                          width: 270,
                                        ),
                                        opacity: 0.2,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              IgnorePointer(
                                child: Observer(builder: (context) {
                                  return PlayAnimation(
                                      tween: (0.0).tweenTo(160.0),
                                      duration: 400.milliseconds,
                                      builder: (context, child, value) {
                                        return CachedNetworkImage(
                                          height: value,
                                          width: value,
                                          placeholder: (context, url) =>
                                              new Container(
                                            color: Colors.transparent,
                                          ),
                                          imageUrl:
                                              'https://raw.githubusercontent.com/fanzeyi/pokemon.json/master/images/${_pokeItem.num}.png',
                                        );
                                      });
                                }),
                              )
                            ],
                          );
                        }),
                  )),
            )
          ],
        ),
      );
    });
  }

  Widget setTipos(List<String> types) {
    List<Widget> lista = [];
    types.forEach((nome) {
      lista.add(
        Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Color.fromARGB(80, 255, 255, 255)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  nome.trim(),
                  style: TextStyle(
                      fontFamily: 'Google',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            )
          ],
        ),
      );
    });
    return Row(
      children: lista,
      crossAxisAlignment: CrossAxisAlignment.start,
    );
  }
}
