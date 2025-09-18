import 'package:hive/hive.dart';
import '../models/favorite_pokemon.dart';
import '../models/pokemon_model.dart';

class FavoritesService {
  static const String _boxName = 'favorites';
  Box<FavoritePokemon>? _box;

  // Inicializar Hive y abrir la caja
  Future<void> init() async {
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox<FavoritePokemon>(_boxName);
      print('DEBUG: Caja de favoritos abierta. Elementos existentes: ${_box!.length}');
    } else {
      _box = Hive.box<FavoritePokemon>(_boxName);
      print('DEBUG: Caja de favoritos ya estaba abierta. Elementos existentes: ${_box!.length}');
    }
  }

  // Agregar Pokémon a favoritos
  Future<void> addToFavorites(Pokemon pokemon) async {
    await init();
    final favoritePokemon = FavoritePokemon.fromPokemon(pokemon);
    await _box!.put(pokemon.id, favoritePokemon);
    print('DEBUG: Pokémon ${pokemon.name} (ID: ${pokemon.id}) agregado a favoritos');
    print('DEBUG: Total de favoritos después de agregar: ${_box!.length}');
  }

  // Remover un Pokémon de favoritos
  Future<void> removeFavorite(int pokemonId) async {
    await init();
    await _box!.delete(pokemonId);
    print('DEBUG: Pokémon con ID $pokemonId removido de favoritos');
    print('DEBUG: Total de favoritos después de remover: ${_box!.length}');
  }

  // Verificar si un Pokémon está en favoritos
  Future<bool> isFavorite(int pokemonId) async {
    await init();
    bool result = _box!.containsKey(pokemonId);
    print('DEBUG: Verificando si Pokémon ID $pokemonId está en favoritos: $result');
    return result;
  }

  // Obtener todos los Pokémon favoritos
  Future<List<FavoritePokemon>> getAllFavorites() async {
    await init();
    return _box!.values.toList();
  }

  // Obtener un Pokémon favorito específico
  Future<FavoritePokemon?> getFavorite(int pokemonId) async {
    await init();
    return _box!.get(pokemonId);
  }

  // Limpiar todos los favoritos
  Future<void> clearAllFavorites() async {
    await init();
    await _box!.clear();
  }

  // Obtener el número total de favoritos
  Future<int> getFavoritesCount() async {
    await init();
    return _box!.length;
  }

  // Cerrar la caja (llamar cuando la app se cierre)
  Future<void> close() async {
    if (_box != null && _box!.isOpen) {
      await _box!.close();
    }
  }
}