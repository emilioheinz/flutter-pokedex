import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/components/poke-card.dart';
import 'package:pokedex/components/poke-loader.dart';
import 'package:pokedex/enums/pokemon-type-enum.dart';
import 'package:pokedex/models/pokemon.dart';
import 'package:pokedex/res/my-colors.dart';
import 'package:pokedex/services/api.dart';

class PokeListPage extends StatefulWidget {
  @override
  _PokeListPageState createState() => _PokeListPageState();
}

class _PokeListPageState extends State<PokeListPage> {
  List<PokemonModel> pokemonsList;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    _getPokemons();
  }

  _getPokemons() async {
    setState(() {
      isLoading = true;
    });

    List<PokemonModel> pokemons = [];
    Response resp = await PokeApi().listPokemons();

    final pokemonsFromApi = JsonDecoder().convert(resp.toString());

    pokemonsFromApi['pokemons'].forEach((pokemon) {
      List<PokeTypeEnum> typesList = [];

      pokemon['types'].forEach((type) {
        int enumIndex = PokemonModel.getEnumIndexFromPokeType(type);
        typesList.add(PokeTypeEnum.values[enumIndex]);
      });

      pokemons.add(PokemonModel.fromJson(pokemon, typesList));
    });

    if (mounted) {
      setState(() {
        pokemonsList = pokemons;
        isLoading = false;
      });
    }
  }

  Widget _buildPokeCards(BuildContext context, int index) {
    return PokeCard(
      pokemon: pokemonsList[index],
    );
  }

  _renderContent() {
    if (isLoading) {
      return Center(
        child: SizedBox(
          height: 25,
          width: 25,
          child: PokeLoader(),
        ),
      );
    }

    return Container(
      child: ListView.separated(
        itemBuilder: _buildPokeCards,
        itemCount: pokemonsList.length,
        separatorBuilder: (context, index) => Divider(
          color: MyColors.dustyGray,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: Duration(milliseconds: 250),
      child: _renderContent(),
    );
  }
}
