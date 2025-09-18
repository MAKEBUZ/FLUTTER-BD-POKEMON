import 'package:hive/hive.dart';
import '../models/custom_move.dart';
import '../models/pokemon_custom_moves.dart';
import '../models/favorite_pokemon.dart';

class CustomMovesService {
  static const String _customMovesBoxName = 'custom_moves';
  static const String _pokemonCustomMovesBoxName = 'pokemon_custom_moves';
  
  Box<CustomMove>? _customMovesBox;
  Box<PokemonCustomMoves>? _pokemonCustomMovesBox;

  // Inicializar las cajas de Hive
  Future<void> init() async {
    if (!Hive.isBoxOpen(_customMovesBoxName)) {
      _customMovesBox = await Hive.openBox<CustomMove>(_customMovesBoxName);
    } else {
      _customMovesBox = Hive.box<CustomMove>(_customMovesBoxName);
    }

    if (!Hive.isBoxOpen(_pokemonCustomMovesBoxName)) {
      _pokemonCustomMovesBox = await Hive.openBox<PokemonCustomMoves>(_pokemonCustomMovesBoxName);
    } else {
      _pokemonCustomMovesBox = Hive.box<PokemonCustomMoves>(_pokemonCustomMovesBoxName);
    }
  }

  // Crear un ataque personalizado
  Future<void> createCustomMove({
    required String name,
    required String type,
    required int power,
    required int accuracy,
    required String description,
  }) async {
    await init();
    
    final customMove = CustomMove.create(
      name: name,
      type: type,
      power: power,
      accuracy: accuracy,
      description: description,
    );
    
    // Usar el nombre como clave para evitar duplicados
    await _customMovesBox!.put(name.toLowerCase(), customMove);
  }

  // Obtener todos los ataques personalizados
  Future<List<CustomMove>> getAllCustomMoves() async {
    await init();
    return _customMovesBox!.values.toList();
  }

  // Obtener un ataque personalizado por nombre
  Future<CustomMove?> getCustomMove(String name) async {
    await init();
    return _customMovesBox!.get(name.toLowerCase());
  }

  // Eliminar un ataque personalizado
  Future<void> deleteCustomMove(String name) async {
    await init();
    await _customMovesBox!.delete(name.toLowerCase());
  }

  // Agregar ataque personalizado a un Pokémon
  Future<void> addCustomMoveToPokemon(int pokemonId, String pokemonName, CustomMove customMove) async {
    await init();
    
    PokemonCustomMoves? pokemonMoves = _pokemonCustomMovesBox!.get(pokemonId);
    
    if (pokemonMoves == null) {
      // Si no existe, crear uno nuevo
      pokemonMoves = PokemonCustomMoves.fromFavoritePokemon(
        pokemonId: pokemonId,
        pokemonName: pokemonName,
        originalMoves: [], // Se actualizará después
      );
    }
    
    final updatedPokemonMoves = pokemonMoves.addCustomMove(customMove);
    await _pokemonCustomMovesBox!.put(pokemonId, updatedPokemonMoves);
  }

  // Remover ataque personalizado de un Pokémon
  Future<void> removeCustomMoveFromPokemon(int pokemonId, int moveIndex) async {
    await init();
    
    PokemonCustomMoves? pokemonMoves = _pokemonCustomMovesBox!.get(pokemonId);
    if (pokemonMoves != null) {
      final updatedPokemonMoves = pokemonMoves.removeCustomMove(moveIndex);
      await _pokemonCustomMovesBox!.put(pokemonId, updatedPokemonMoves);
    }
  }

  // Obtener ataques personalizados de un Pokémon
  Future<PokemonCustomMoves?> getPokemonCustomMoves(int pokemonId) async {
    await init();
    return _pokemonCustomMovesBox!.get(pokemonId);
  }

  // Inicializar ataques personalizados para un Pokémon favorito
  Future<void> initializePokemonCustomMoves(FavoritePokemon favoritePokemon) async {
    await init();
    
    // Solo crear si no existe
    if (!_pokemonCustomMovesBox!.containsKey(favoritePokemon.id)) {
      final pokemonMoves = PokemonCustomMoves.fromFavoritePokemon(
        pokemonId: favoritePokemon.id,
        pokemonName: favoritePokemon.name,
        originalMoves: favoritePokemon.moves,
      );
      
      await _pokemonCustomMovesBox!.put(favoritePokemon.id, pokemonMoves);
    }
  }

  // Obtener todos los ataques (originales + personalizados) de un Pokémon
  Future<List<String>> getAllPokemonMoves(int pokemonId) async {
    await init();
    
    final pokemonMoves = await getPokemonCustomMoves(pokemonId);
    if (pokemonMoves != null) {
      return pokemonMoves.getAllMoves();
    }
    
    return [];
  }

  // Verificar si un Pokémon tiene ataques personalizados
  Future<bool> hasCustomMoves(int pokemonId) async {
    await init();
    
    final pokemonMoves = await getPokemonCustomMoves(pokemonId);
    return pokemonMoves != null && pokemonMoves.customMoves.isNotEmpty;
  }

  // Cerrar las cajas
  Future<void> close() async {
    await _customMovesBox?.close();
    await _pokemonCustomMovesBox?.close();
  }
}