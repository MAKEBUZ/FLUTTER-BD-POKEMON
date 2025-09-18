import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/favorite_pokemon.dart';
import '../services/favorites_service.dart';

class TeamController extends GetxController {
  final FavoritesService _favoritesService = FavoritesService();
  final RxList<FavoritePokemon> favorites = <FavoritePokemon>[].obs;
  final RxBool isLoading = false.obs;

  // Colores para los tipos de Pokémon
  final Map<String, int> typeColors = {
    'normal': 0xFFA8A878,
    'fire': 0xFFF08030,
    'water': 0xFF6890F0,
    'electric': 0xFFF8D030,
    'grass': 0xFF78C850,
    'ice': 0xFF98D8D8,
    'fighting': 0xFFC03028,
    'poison': 0xFFA040A0,
    'ground': 0xFFE0C068,
    'flying': 0xFFA890F0,
    'psychic': 0xFFF85888,
    'bug': 0xFFA8B820,
    'rock': 0xFFB8A038,
    'ghost': 0xFF705898,
    'dragon': 0xFF7038F8,
    'dark': 0xFF705848,
    'steel': 0xFFB8B8D0,
    'fairy': 0xFFEE99AC,
  };

  @override
  void onInit() {
    super.onInit();
    loadFavorites();
  }

  @override
  void onClose() {
    _favoritesService.close();
    super.onClose();
  }

  // Cargar favoritos desde el servicio
  Future<void> loadFavorites() async {
    try {
      isLoading.value = true;
      final List<FavoritePokemon> loadedFavorites = await _favoritesService.getAllFavorites();
      favorites.assignAll(loadedFavorites);
      print('DEBUG: Favoritos cargados: ${favorites.length}');
      
      // Mostrar mensaje de confirmación
      if (loadedFavorites.isNotEmpty) {
        Get.snackbar(
          'Equipo Actualizado',
          'Se encontraron ${loadedFavorites.length} Pokémon en tu equipo',
          backgroundColor: Colors.green,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Equipo Vacío',
          'No hay Pokémon en tu equipo',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron cargar los favoritos: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Remover un favorito
  Future<void> removeFavorite(int pokemonId) async {
    try {
      await _favoritesService.removeFavorite(pokemonId);
      favorites.removeWhere((pokemon) => pokemon.id == pokemonId);
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudo remover el Pokémon: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Limpiar todos los favoritos
  Future<void> clearAllFavorites() async {
    try {
      // Remover todos los favoritos uno por uno
      final List<int> idsToRemove = favorites.map((pokemon) => pokemon.id).toList();
      for (int id in idsToRemove) {
        await _favoritesService.removeFavorite(id);
      }
      favorites.clear();
    } catch (e) {
      Get.snackbar(
        'Error',
        'No se pudieron limpiar los favoritos: $e',
        backgroundColor: Get.theme.colorScheme.error,
        colorText: Get.theme.colorScheme.onError,
      );
    }
  }

  // Obtener color del tipo
  int getTypeColor(String type) {
    return typeColors[type.toLowerCase()] ?? 0xFF78C850;
  }

  // Refrescar la lista
  @override
  Future<void> refresh() async {
    await loadFavorites();
  }
}