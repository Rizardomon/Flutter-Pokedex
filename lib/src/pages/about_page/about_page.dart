import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:md2_tab_indicator/md2_tab_indicator.dart';
import 'package:mobx/mobx.dart';
import 'package:pokedex/models/specie.dart';
import 'package:pokedex/src/pages/about_page/widgets/about_tab.dart';
import 'package:pokedex/src/pages/about_page/widgets/evolution_tab.dart';
import 'package:pokedex/src/pages/about_page/widgets/status_tab.dart';
import 'package:pokedex/stores/pokeapi_store.dart';
import 'package:pokedex/stores/pokeapiv2_store.dart';

class AboutPage extends StatefulWidget {
  @override
  _AboutPageState createState() => _AboutPageState();
}

class _AboutPageState extends State<AboutPage> with TickerProviderStateMixin {
  TabController _tabController;
  PageController _pageController;
  PokeApiStore _pokemonStore;
  PokeApiV2Store _pokeApiV2Store;
  ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pokemonStore = GetIt.instance<PokeApiStore>();
    _pokeApiV2Store = GetIt.instance<PokeApiV2Store>();
    _pageController = PageController(initialPage: 0);

    _disposer = reaction(
        (f) => _pokemonStore.pokemonAtual,
        (r) => _pageController.animateToPage(0,
            duration: Duration(milliseconds: 300), curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _disposer(); // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(10),
          child: Observer(
            builder: (context) {
              _pokeApiV2Store.getInfoPokemon(_pokemonStore.pokemonAtual.name);
              _pokeApiV2Store
                  .getInfoSpecie(_pokemonStore.pokemonAtual.id.toString());
              return TabBar(
                onTap: (index) {
                  _pageController.animateToPage(index,
                      duration: Duration(milliseconds: 300),
                      curve: Curves.easeInOut);
                },
                controller: _tabController,
                labelStyle: TextStyle(
                    fontFamily: 'Google',
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
                indicatorSize: TabBarIndicatorSize.label, //makes it better
                labelColor: _pokemonStore.corPokemon, //Google's sweet blue
                unselectedLabelColor: Color(0xff5f6368), //niceish grey
                isScrollable: true, //up to your taste
                indicator: MD2Indicator(
                    //it begins here
                    indicatorHeight: 3,
                    indicatorColor: _pokemonStore.corPokemon,
                    indicatorSize: MD2IndicatorSize
                        .normal //3 different modes tiny-normal-full
                    ),
                tabs: <Widget>[
                  Tab(
                    text: "About",
                  ),
                  Tab(
                    text: "Evolution",
                  ),
                  Tab(
                    text: "Status",
                  ),
                ],
              );
            },
          ),
        ),
      ),
      body: PageView(
        onPageChanged: (index) {
          _tabController.animateTo(index,
              duration: Duration(milliseconds: 300));
        },
        controller: _pageController,
        children: [
          Container(
            child: AboutTab(),
          ),
          Container(
            child: EvolutionTab(),
          ),
          Container(
            child: StatusTab(),
          ),
        ],
      ),
    );
  }
}
