import 'package:get/get.dart';
import '../models/pokemon_model.dart';
import '../services/pokemon_service.dart';
import '../services/favorites_service.dart';
import 'team_controller.dart';

class PokemonController extends GetxController {
  final PokemonService _pokemonService = PokemonService();
  final FavoritesService _favoritesService = FavoritesService();
  
  // Variables observables
  final Rx<Pokemon?> pokemon = Rx<Pokemon?>(null);
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxBool isFavorite = false.obs;
  
  // Mapa de colores según el tipo de Pokémon
  final Map<String, int> typeColors = {
    'Normal': 0xFFA8A878,
    'Fire': 0xFFF08030,
    'Water': 0xFF6890F0,
    'Electric': 0xFFF8D030,
    'Grass': 0xFF78C850,
    'Ice': 0xFF98D8D8,
    'Fighting': 0xFFC03028,
    'Poison': 0xFFA040A0,
    'Ground': 0xFFE0C068,
    'Flying': 0xFFA890F0,
    'Psychic': 0xFFF85888,
    'Bug': 0xFFA8B820,
    'Rock': 0xFFB8A038,
    'Ghost': 0xFF705898,
    'Dragon': 0xFF7038F8,
    'Dark': 0xFF705848,
    'Steel': 0xFFB8B8D0,
    'Fairy': 0xFFEE99AC
  };
  
  // Método para buscar un Pokémon
  Future<void> searchPokemon(String nameOrId) async {
    if (nameOrId.isEmpty) return;
    
    try {
      isLoading.value = true;
      error.value = '';
      searchQuery.value = nameOrId;
      
      final Pokemon result = await _pokemonService.getPokemon(nameOrId);
      pokemon.value = result;
      
      // Verificar si está en favoritos
      await _checkIfFavorite(result.id);
    } catch (e) {
      error.value = 'No se encontró el Pokémon. Intenta con otro nombre o número.';
      pokemon.value = null;
      isFavorite.value = false;
    } finally {
      isLoading.value = false;
    }
  }
  
  // Verificar si el Pokémon actual está en favoritos
  Future<void> _checkIfFavorite(int pokemonId) async {
    isFavorite.value = await _favoritesService.isFavorite(pokemonId);
  }
  
  // Alternar estado de favorito
  Future<void> toggleFavorite() async {
    if (pokemon.value == null) return;
    
    try {
      if (isFavorite.value) {
        await _favoritesService.removeFavorite(pokemon.value!.id);
        isFavorite.value = false;
        Get.snackbar(
          'Removido',
          '${pokemon.value!.name} fue removido del equipo',
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        await _favoritesService.addToFavorites(pokemon.value!);
        isFavorite.value = true;
        Get.snackbar(
          'Agregado al Equipo',
          '${pokemon.value!.name} fue agregado a tu equipo',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
      
      // Actualizar el equipo si el controlador existe
      if (Get.isRegistered<TeamController>()) {
        final teamController = Get.find<TeamController>();
        await teamController.loadFavorites();
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo actualizar el estado de favorito',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
  
  // Obtener el color de fondo según el tipo principal del Pokémon
  int getBackgroundColor() {
    if (pokemon.value == null || pokemon.value!.types.isEmpty) {
      return 0xFFFFFFFF; // Blanco por defecto
    }
    
    // Usar el primer tipo como tipo principal
    String primaryType = pokemon.value!.types[0];
    return typeColors[primaryType] ?? 0xFFFFFFFF;
  }
  
  // Limpiar la búsqueda
  void clearSearch() {
    pokemon.value = null;
    error.value = '';
    searchQuery.value = '';
    isFavorite.value = false;
  }
}