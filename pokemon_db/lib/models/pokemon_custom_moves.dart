import 'package:hive/hive.dart';
import 'custom_move.dart';

part 'pokemon_custom_moves.g.dart';

@HiveType(typeId: 2)
class PokemonCustomMoves extends HiveObject {
  @HiveField(0)
  final int pokemonId;

  @HiveField(1)
  final String pokemonName;

  @HiveField(2)
  final List<String> originalMoves;

  @HiveField(3)
  final List<CustomMove> customMoves;

  @HiveField(4)
  final DateTime lastModified;

  PokemonCustomMoves({
    required this.pokemonId,
    required this.pokemonName,
    required this.originalMoves,
    required this.customMoves,
    required this.lastModified,
  });

  // Factory constructor para crear desde un Pokémon favorito
  factory PokemonCustomMoves.fromFavoritePokemon({
    required int pokemonId,
    required String pokemonName,
    required List<String> originalMoves,
  }) {
    return PokemonCustomMoves(
      pokemonId: pokemonId,
      pokemonName: pokemonName,
      originalMoves: originalMoves,
      customMoves: [],
      lastModified: DateTime.now(),
    );
  }

  // Agregar un ataque personalizado
  PokemonCustomMoves addCustomMove(CustomMove move) {
    final updatedCustomMoves = List<CustomMove>.from(customMoves);
    updatedCustomMoves.add(move);
    
    return PokemonCustomMoves(
      pokemonId: pokemonId,
      pokemonName: pokemonName,
      originalMoves: originalMoves,
      customMoves: updatedCustomMoves,
      lastModified: DateTime.now(),
    );
  }

  // Remover un ataque personalizado
  PokemonCustomMoves removeCustomMove(int index) {
    final updatedCustomMoves = List<CustomMove>.from(customMoves);
    if (index >= 0 && index < updatedCustomMoves.length) {
      updatedCustomMoves.removeAt(index);
    }
    
    return PokemonCustomMoves(
      pokemonId: pokemonId,
      pokemonName: pokemonName,
      originalMoves: originalMoves,
      customMoves: updatedCustomMoves,
      lastModified: DateTime.now(),
    );
  }

  // Obtener todos los ataques (originales + personalizados)
  List<String> getAllMoves() {
    final allMoves = List<String>.from(originalMoves);
    allMoves.addAll(customMoves.map((move) => move.name));
    return allMoves;
  }

  // Obtener solo los nombres de ataques personalizados
  List<String> getCustomMoveNames() {
    return customMoves.map((move) => move.name).toList();
  }

  @override
  String toString() {
    return 'PokemonCustomMoves(pokemonId: $pokemonId, pokemonName: $pokemonName, customMoves: ${customMoves.length})';
  }
}