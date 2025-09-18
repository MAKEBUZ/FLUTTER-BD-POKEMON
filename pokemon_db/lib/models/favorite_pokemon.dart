import 'package:hive/hive.dart';
import 'pokemon_model.dart';

part 'favorite_pokemon.g.dart';

@HiveType(typeId: 0)
class FavoritePokemon extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final List<String> types;

  @HiveField(4)
  final List<String> weaknesses;

  @HiveField(5)
  final List<String> moves;

  @HiveField(6)
  final DateTime addedDate;

  @HiveField(7)
  final bool hasCustomMoves;

  FavoritePokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.weaknesses,
    required this.moves,
    required this.addedDate,
    this.hasCustomMoves = false,
  });

  // Factory constructor para crear desde Pokemon
  factory FavoritePokemon.fromPokemon(Pokemon pokemon, {bool hasCustomMoves = false}) {
    return FavoritePokemon(
      id: pokemon.id,
      name: pokemon.name,
      imageUrl: pokemon.imageUrl,
      types: pokemon.types,
      weaknesses: pokemon.weaknesses,
      moves: pokemon.moves,
      addedDate: DateTime.now(),
      hasCustomMoves: hasCustomMoves,
    );
  }

  // Convertir a Pokemon regular
  Pokemon toPokemon() {
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      types: types,
      weaknesses: weaknesses,
      moves: moves,
    );
  }
}