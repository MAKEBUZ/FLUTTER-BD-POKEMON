import 'package:hive/hive.dart';
import '../models/team_pokemon_model.dart';
import '../models/pokemon_model.dart';
import 'database_service.dart';

class TeamService {
  static const String _boxName = 'team_pokemon';
  static Box<TeamPokemon>? _box;

  // Inicializar el servicio
  static Future<void> init() async {
    try {
      if (!Hive.isBoxOpen(_boxName)) {
        _box = await Hive.openBox<TeamPokemon>(_boxName);
        print('TeamService: Box opened successfully');
      } else {
        _box = Hive.box<TeamPokemon>(_boxName);
        print('TeamService: Using existing open box');
      }
      
      // Inicializar SQLite
      await DatabaseService.isDatabaseReady();
      print('TeamService: SQLite database ready');
    } catch (e) {
      print('TeamService: Error initializing - $e');
      rethrow;
    }
  }

  // Obtener la caja, inicializándola si es necesario
  Future<Box<TeamPokemon>> _getBox() async {
    if (_box == null || !_box!.isOpen) {
      await init();
    }
    return _box!;
  }

  // Agregar Pokémon al equipo
  Future<bool> addPokemonToTeam(dynamic pokemon) async {
    try {
      final box = await _getBox();
      
      // Verificar si ya está en el equipo
      if (isPokemonInTeam(pokemon.id)) {
        print('DEBUG: Pokémon ${pokemon.name} ya está en el equipo');
        return false;
      }

      // Verificar límite de equipo (máximo 6 Pokémon)
      if (box.length >= 6) {
        print('DEBUG: Equipo lleno (máximo 6 Pokémon)');
        return false;
      }

      // Cargar movimientos guardados desde SQLite
      final savedMoves = await DatabaseService.getPokemonMoves(pokemon.id);
      
      final teamPokemon = TeamPokemon.fromPokemon(pokemon);
      if (savedMoves.isNotEmpty) {
        teamPokemon.moves = savedMoves;
        print('TeamService: Loaded ${savedMoves.length} saved moves for ${pokemon.name}');
      }
      
      await box.put(pokemon.id, teamPokemon);
      
      print('DEBUG: ${pokemon.name} agregado al equipo');
      return true;
    } catch (e) {
      print('ERROR: Error al agregar Pokémon al equipo: $e');
      return false;
    }
  }

  // Eliminar Pokémon del equipo
  Future<bool> removePokemonFromTeam(int pokemonId) async {
    try {
      final box = await _getBox();
      await box.delete(pokemonId);
      print('DEBUG: Pokémon ID $pokemonId eliminado del equipo');
      return true;
    } catch (e) {
      print('ERROR: Error al eliminar Pokémon del equipo: $e');
      return false;
    }
  }

  // Verificar si un Pokémon está en el equipo
  bool isPokemonInTeam(int pokemonId) {
    try {
      if (_box == null || !_box!.isOpen) return false;
      return _box!.containsKey(pokemonId);
    } catch (e) {
      print('ERROR: Error al verificar Pokémon en equipo: $e');
      return false;
    }
  }

  // Obtener todos los Pokémon del equipo
  List<TeamPokemon> getAllTeamPokemon() {
    try {
      if (_box == null || !_box!.isOpen) return [];
      return _box!.values.toList()
        ..sort((a, b) => a.addedAt.compareTo(b.addedAt));
    } catch (e) {
      print('ERROR: Error al obtener Pokémon del equipo: $e');
      return [];
    }
  }

  // Obtener un Pokémon específico del equipo
  TeamPokemon? getTeamPokemon(int pokemonId) {
    try {
      if (_box == null || !_box!.isOpen) return null;
      return _box!.get(pokemonId);
    } catch (e) {
      print('ERROR: Error al obtener Pokémon específico: $e');
      return null;
    }
  }

  // Actualizar movimientos de un Pokémon
  Future<bool> updatePokemonMoves(int pokemonId, List<String> newMoves) async {
    try {
      final box = await _getBox();
      final teamPokemon = box.get(pokemonId);
      
      if (teamPokemon == null) {
        print('DEBUG: Pokémon ID $pokemonId no encontrado en el equipo');
        return false;
      }

      final updatedPokemon = teamPokemon.copyWith(moves: newMoves);
      await box.put(pokemonId, updatedPokemon);
      
      // Guardar movimientos en SQLite
      final success = await DatabaseService.savePokemonMoves(
        pokemonId: pokemonId,
        pokemonName: teamPokemon.name,
        moves: newMoves,
      );
      
      if (success) {
        print('DEBUG: Movimientos actualizados para ${teamPokemon.name}');
        return true;
      } else {
        print('ERROR: Error guardando movimientos en SQLite');
        return false;
      }
    } catch (e) {
      print('ERROR: Error al actualizar movimientos: $e');
      return false;
    }
  }

  // Limpiar todo el equipo
  Future<bool> clearTeam() async {
    try {
      final box = await _getBox();
      await box.clear();
      print('DEBUG: Equipo limpiado completamente');
      return true;
    } catch (e) {
      print('ERROR: Error al limpiar equipo: $e');
      return false;
    }
  }

  // Obtener estadísticas del equipo
  Map<String, dynamic> getTeamStats() {
    try {
      final team = getAllTeamPokemon();
      final typeCount = <String, int>{};
      
      for (final pokemon in team) {
        for (final type in pokemon.types) {
          typeCount[type] = (typeCount[type] ?? 0) + 1;
        }
      }

      return {
        'totalPokemon': team.length,
        'maxCapacity': 6,
        'typeDistribution': typeCount,
        'oldestMember': team.isNotEmpty ? team.first.addedAt : null,
        'newestMember': team.isNotEmpty ? team.last.addedAt : null,
      };
    } catch (e) {
      print('ERROR: Error al obtener estadísticas: $e');
      return {
        'totalPokemon': 0,
        'maxCapacity': 6,
        'typeDistribution': <String, int>{},
        'oldestMember': null,
        'newestMember': null,
      };
    }
  }

  // Cerrar el servicio
  Future<void> close() async {
    try {
      await _box?.close();
      print('DEBUG: TeamService cerrado');
    } catch (e) {
      print('ERROR: Error al cerrar TeamService: $e');
    }
  }
}