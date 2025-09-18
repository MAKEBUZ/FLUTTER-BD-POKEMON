import 'package:hive/hive.dart';
import 'pokemon_model.dart';

part 'team_pokemon.g.dart';

@HiveType(typeId: 0)
class TeamPokemon extends HiveObject {
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
  List<String> attacks;

  @HiveField(6)
  final Map<String, int> stats;

  TeamPokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.weaknesses,
    required this.attacks,
    required this.stats,
  });

  // Convertir desde Pokemon regular
  factory TeamPokemon.fromPokemon(Pokemon pokemon) {
    return TeamPokemon(
      id: pokemon.id,
      name: pokemon.name,
      imageUrl: pokemon.imageUrl,
      types: pokemon.types,
      weaknesses: pokemon.weaknesses,
      attacks: List<String>.from(pokemon.attacks),
      stats: Map<String, int>.from(pokemon.stats),
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
      attacks: attacks,
      stats: stats,
    );
  }
}