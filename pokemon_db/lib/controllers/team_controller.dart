import 'package:get/get.dart';
import '../models/team_pokemon_model.dart';
import '../services/team_service.dart';

class TeamController extends GetxController {
  final TeamService _teamService = TeamService();
  
  // Variables observables
  final RxList<TeamPokemon> teamPokemon = <TeamPokemon>[].obs;
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final Rx<TeamPokemon?> selectedPokemon = Rx<TeamPokemon?>(null);
  final RxMap<String, dynamic> teamStats = <String, dynamic>{}.obs;

  @override
  void onInit() {
    super.onInit();
    initializeTeamService();
  }

  // Inicializar el servicio de equipo
  Future<void> initializeTeamService() async {
    try {
      isLoading.value = true;
      error.value = '';
      
      await _teamService.init();
      await loadTeam();
      updateTeamStats();
      
      print('DEBUG: TeamController inicializado correctamente');
    } catch (e) {
      print('ERROR: Error al inicializar TeamController: $e');
      error.value = 'Error al inicializar el equipo';
    } finally {
      isLoading.value = false;
    }
  }

  // Cargar equipo desde HIVE
  Future<void> loadTeam() async {
    try {
      final team = _teamService.getAllTeamPokemon();
      teamPokemon.value = team;
      print('DEBUG: Equipo cargado: ${team.length} Pokémon');
    } catch (e) {
      print('ERROR: Error al cargar equipo: $e');
      error.value = 'Error al cargar el equipo';
    }
  }

  // Recargar equipo
  Future<void> reloadTeam() async {
    try {
      isLoading.value = true;
      await loadTeam();
      updateTeamStats();
      
      Get.snackbar(
        'Equipo Recargado',
        'El equipo se ha actualizado correctamente',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } catch (e) {
      print('ERROR: Error al recargar equipo: $e');
      Get.snackbar(
        'Error',
        'No se pudo recargar el equipo',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 2),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Agregar Pokémon al equipo
  Future<bool> addPokemonToTeam(dynamic pokemon) async {
    try {
      if (teamPokemon.length >= 6) {
        Get.snackbar(
          'Equipo Lleno',
          'No puedes tener más de 6 Pokémon en tu equipo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return false;
      }

      if (_teamService.isPokemonInTeam(pokemon.id)) {
        Get.snackbar(
          'Pokémon Duplicado',
          '${pokemon.name} ya está en tu equipo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return false;
      }

      final success = await _teamService.addPokemonToTeam(pokemon);
      
      if (success) {
        await loadTeam();
        updateTeamStats();
        
        Get.snackbar(
          'Pokémon Agregado',
          '${pokemon.name} se agregó a tu equipo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudo agregar ${pokemon.name} al equipo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      print('ERROR: Error al agregar Pokémon al equipo: $e');
      Get.snackbar(
        'Error',
        'Error inesperado al agregar Pokémon',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  // Eliminar Pokémon del equipo
  Future<void> removePokemonFromTeam(int pokemonId) async {
    try {
      final pokemon = _teamService.getTeamPokemon(pokemonId);
      final success = await _teamService.removePokemonFromTeam(pokemonId);
      
      if (success) {
        await loadTeam();
        updateTeamStats();
        
        // Si el Pokémon eliminado era el seleccionado, deseleccionarlo
        if (selectedPokemon.value?.id == pokemonId) {
          selectedPokemon.value = null;
        }
        
        Get.snackbar(
          'Pokémon Eliminado',
          '${pokemon?.name ?? 'Pokémon'} fue eliminado del equipo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo eliminar el Pokémon del equipo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('ERROR: Error al eliminar Pokémon: $e');
      Get.snackbar(
        'Error',
        'Error inesperado al eliminar Pokémon',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    }
  }

  // Limpiar todo el equipo
  Future<void> clearTeam() async {
    try {
      isLoading.value = true;
      final success = await _teamService.clearTeam();
      
      if (success) {
        teamPokemon.clear();
        selectedPokemon.value = null;
        updateTeamStats();
        
        Get.snackbar(
          'Equipo Limpiado',
          'Todos los Pokémon fueron eliminados del equipo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
      } else {
        Get.snackbar(
          'Error',
          'No se pudo limpiar el equipo',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
      }
    } catch (e) {
      print('ERROR: Error al limpiar equipo: $e');
      Get.snackbar(
        'Error',
        'Error inesperado al limpiar equipo',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Seleccionar Pokémon para ver detalles
  void selectPokemon(TeamPokemon pokemon) {
    selectedPokemon.value = pokemon;
    print('DEBUG: Pokémon seleccionado: ${pokemon.name}');
    
    // Navegar a vista de detalles del equipo
    Get.toNamed('/team-detail', arguments: pokemon);
  }

  // Verificar si un Pokémon está en el equipo
  bool isPokemonInTeam(int pokemonId) {
    return _teamService.isPokemonInTeam(pokemonId);
  }

  // Actualizar movimientos de un Pokémon
  Future<bool> updatePokemonMoves(int pokemonId, List<String> newMoves) async {
    try {
      final success = await _teamService.updatePokemonMoves(pokemonId, newMoves);
      
      if (success) {
        await loadTeam();
        
        // Actualizar Pokémon seleccionado si es el mismo
        if (selectedPokemon.value?.id == pokemonId) {
          selectedPokemon.value = _teamService.getTeamPokemon(pokemonId);
        }
        
        Get.snackbar(
          'Movimientos Actualizados',
          'Los movimientos se guardaron correctamente',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 2),
        );
        return true;
      } else {
        Get.snackbar(
          'Error',
          'No se pudieron actualizar los movimientos',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 3),
        );
        return false;
      }
    } catch (e) {
      print('ERROR: Error al actualizar movimientos: $e');
      Get.snackbar(
        'Error',
        'Error inesperado al actualizar movimientos',
        snackPosition: SnackPosition.BOTTOM,
        duration: const Duration(seconds: 3),
      );
      return false;
    }
  }

  // Actualizar estadísticas del equipo
  void updateTeamStats() {
    try {
      teamStats.value = _teamService.getTeamStats();
    } catch (e) {
      print('ERROR: Error al actualizar estadísticas: $e');
    }
  }

  // Obtener color de fondo basado en tipos del equipo
  int getTeamBackgroundColor() {
    if (teamPokemon.isEmpty) return 0xFFFF5252; // Rojo por defecto
    
    // Contar tipos más comunes
    final typeCount = <String, int>{};
    for (final pokemon in teamPokemon) {
      for (final type in pokemon.types) {
        typeCount[type] = (typeCount[type] ?? 0) + 1;
      }
    }
    
    if (typeCount.isEmpty) return 0xFFFF5252;
    
    // Obtener tipo más común
    final mostCommonType = typeCount.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    // Colores por tipo (mismos que en PokemonController)
    final typeColors = {
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
    
    return typeColors[mostCommonType] ?? 0xFFFF5252;
  }

  @override
  void onClose() {
    _teamService.close();
    super.onClose();
  }
}