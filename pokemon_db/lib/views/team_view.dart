import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../controllers/pokemon_controller.dart';
import 'team_detail_view.dart';

class TeamView extends StatelessWidget {
  final TeamController teamController = Get.put(TeamController());
  final PokemonController pokemonController = Get.find<PokemonController>();

  TeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Mi Equipo Pokémon',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Colors.red.shade600,
        elevation: 0,
        actions: [
          // Botón Recargar
          IconButton(
            onPressed: () => teamController.reloadTeam(),
            icon: const Icon(Icons.refresh, color: Colors.white),
            tooltip: 'Recargar equipo',
          ),
          // Botón Borrar todo
          IconButton(
            onPressed: () => _showClearTeamDialog(context),
            icon: const Icon(Icons.delete_sweep, color: Colors.white),
            tooltip: 'Borrar todo el equipo',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.red.shade400.withOpacity(0.3),
              Colors.red.shade200.withOpacity(0.1),
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Column(
          children: [
            // Botones principales
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => teamController.reloadTeam(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Recargar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade600,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => _showClearTeamDialog(context),
                      icon: const Icon(Icons.delete_sweep),
                      label: const Text('Borrar Todo'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade800,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // Lista de Pokémon del equipo
            Expanded(
              child: Obx(() {
                if (teamController.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
                    ),
                  );
                }
                
                if (teamController.teamPokemon.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.catching_pokemon,
                          size: 80,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tu equipo está vacío',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Busca Pokémon y agrégalos a tu equipo',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: teamController.teamPokemon.length,
                  itemBuilder: (context, index) {
                    final pokemon = teamController.teamPokemon[index];
                    return _buildPokemonCard(pokemon, index);
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(dynamic pokemon, int index) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.white,
              Colors.red.shade50,
            ],
          ),
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.all(16),
          leading: Hero(
            tag: 'team-pokemon-${pokemon.id}',
            child: Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.red.shade100,
              ),
              child: ClipOval(
                child: Image.network(
                  pokemon.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.catching_pokemon,
                      color: Colors.red.shade400,
                      size: 30,
                    );
                  },
                ),
              ),
            ),
          ),
          title: Text(
            pokemon.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${pokemon.id}',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Wrap(
                spacing: 4,
                children: pokemon.types.map<Widget>((type) {
                  return Chip(
                    label: Text(
                      type,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                    ),
                    backgroundColor: Color(pokemonController.typeColors[type] ?? 0xFF78C850),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                  );
                }).toList(),
              ),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Botón para ver detalles
              IconButton(
                onPressed: () => teamController.selectPokemon(pokemon),
                icon: Icon(
                  Icons.info_outline,
                  color: Colors.red.shade600,
                ),
                tooltip: 'Ver detalles',
              ),
              // Botón para eliminar del equipo
              IconButton(
                onPressed: () => _showRemovePokemonDialog(pokemon),
                icon: Icon(
                  Icons.remove_circle_outline,
                  color: Colors.red.shade800,
                ),
                tooltip: 'Eliminar del equipo',
              ),
            ],
          ),
          onTap: () {
            teamController.selectPokemon(pokemon);
            Get.to(() => const TeamDetailView(), arguments: pokemon);
          },
        ),
      ),
    );
  }

  void _showClearTeamDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Borrar todo el equipo'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los Pokémon de tu equipo?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              teamController.clearTeam();
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Borrar Todo'),
          ),
        ],
      ),
    );
  }

  void _showRemovePokemonDialog(dynamic pokemon) {
    Get.dialog(
      AlertDialog(
        title: Text('Eliminar ${pokemon.name}'),
        content: Text('¿Quieres eliminar a ${pokemon.name} de tu equipo?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              teamController.removePokemonFromTeam(pokemon.id);
              Get.back();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
  }
}