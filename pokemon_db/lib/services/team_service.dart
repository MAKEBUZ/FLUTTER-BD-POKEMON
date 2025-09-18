import 'package:hive/hive.dart';
import '../models/pokemon_model.dart';
import '../models/team_pokemon.dart';

class TeamService {
  static const String _boxName = 'team_pokemon';
  late Box<TeamPokemon> _teamBox;

  // Inicializar el servicio
  Future<void> init() async {
    _teamBox = await Hive.openBox<TeamPokemon>(_boxName);
  }

  // Agregar Pokemon al equipo
  Future<void> addToTeam(Pokemon pokemon) async {
    final teamPokemon = TeamPokemon.fromPokemon(pokemon);
    await _teamBox.put(pokemon.id, teamPokemon);
  }

  // Remover Pokemon del equipo
  Future<void> removeFromTeam(int pokemonId) async {
    await _teamBox.delete(pokemonId);
  }

  // Obtener todos los Pokemon del equipo
  List<TeamPokemon> getTeam() {
    return _teamBox.values.toList();
  }

  // Verificar si un Pokemon está en el equipo
  bool isInTeam(int pokemonId) {
    return _teamBox.containsKey(pokemonId);
  }

  // Limpiar todo el equipo
  Future<void> clearTeam() async {
    await _teamBox.clear();
  }

  // Actualizar ataques de un Pokemon
  Future<void> updatePokemonAttacks(int pokemonId, List<String> newAttacks) async {
    final teamPokemon = _teamBox.get(pokemonId);
    if (teamPokemon != null) {
      teamPokemon.attacks = newAttacks;
      await teamPokemon.save();
    }
  }

  // Obtener un Pokemon específico del equipo
  TeamPokemon? getTeamPokemon(int pokemonId) {
    return _teamBox.get(pokemonId);
  }

  // Obtener el número de Pokemon en el equipo
  int getTeamSize() {
    return _teamBox.length;
  }
}