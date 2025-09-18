import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../controllers/pokemon_controller.dart';
import '../models/team_pokemon.dart';

class TeamView extends StatelessWidget {
  final TeamController teamController = Get.put(TeamController());
  final PokemonController pokemonController = Get.find<PokemonController>();

  TeamView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Equipo Pokémon'),
        centerTitle: true,
        backgroundColor: Colors.red.shade400,
        foregroundColor: Colors.white,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.red.shade50,
              Colors.red.shade100.withOpacity(0.3),
            ],
          ),
        ),
        child: Column(
          children: [
            // Botones principales
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => teamController.reloadTeam(),
                      icon: const Icon(Icons.refresh),
                      label: const Text('Recargar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue.shade600,
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
                        backgroundColor: Colors.red.shade600,
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

            // Contenido principal
            Expanded(
              child: Obx(() {
                if (teamController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (teamController.team.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.catching_pokemon,
                          size: 100,
                          color: Colors.red.shade300,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Tu equipo está vacío',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.red.shade700,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Busca Pokémon y agrégalos a tu equipo',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red.shade500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  );
                }

                return Row(
                  children: [
                    // Lista de Pokemon del equipo
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Text(
                              'Equipo (${teamController.teamSize})',
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                              itemCount: teamController.team.length,
                              itemBuilder: (context, index) {
                                final pokemon = teamController.team[index];
                                return _buildPokemonCard(pokemon);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Detalles del Pokemon seleccionado
                    Expanded(
                      flex: 1,
                      child: Obx(() {
                        final selectedPokemon = teamController.selectedPokemon.value;
                        if (selectedPokemon == null) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.touch_app,
                                  size: 80,
                                  color: Colors.red.shade300,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Selecciona un Pokémon',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.red.shade600,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'para ver sus detalles',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.red.shade400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        return _buildPokemonDetails(selectedPokemon);
                      }),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPokemonCard(TeamPokemon pokemon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => teamController.selectPokemon(pokemon),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                Colors.white,
                Color(pokemonController.typeColors[pokemon.types.first] ?? 0xFF78C850)
                    .withOpacity(0.1),
              ],
            ),
          ),
          child: Row(
            children: [
              // Imagen
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  pokemon.imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.broken_image),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),

              // Información
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      pokemon.name,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 4,
                      children: pokemon.types
                          .map((type) => Chip(
                                label: Text(
                                  type,
                                  style: const TextStyle(
                                    fontSize: 10,
                                    color: Colors.white,
                                  ),
                                ),
                                backgroundColor: Color(
                                    pokemonController.typeColors[type] ?? 0xFF78C850),
                                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                              ))
                          .toList(),
                    ),
                  ],
                ),
              ),

              // Botón eliminar
              IconButton(
                onPressed: () => _showRemovePokemonDialog(pokemon),
                icon: const Icon(Icons.remove_circle_outline),
                color: Colors.red.shade600,
                tooltip: 'Eliminar del equipo',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonDetails(TeamPokemon pokemon) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.red.shade100,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Imagen y nombre
            Image.network(
              pokemon.imageUrl,
              height: 120,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.broken_image, size: 60),
                );
              },
            ),
            const SizedBox(height: 12),
            Text(
              pokemon.name,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '#${pokemon.id}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Tipos
            _buildDetailSection('Tipos', pokemon.types.map((type) => 
              Chip(
                label: Text(type, style: const TextStyle(color: Colors.white, fontSize: 12)),
                backgroundColor: Color(pokemonController.typeColors[type] ?? 0xFF78C850),
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              )
            ).toList()),

            // Debilidades
            if (pokemon.weaknesses.isNotEmpty)
              _buildDetailSection('Debilidades', pokemon.weaknesses.map((weakness) => 
                Chip(
                  label: Text(weakness, style: const TextStyle(color: Colors.white, fontSize: 12)),
                  backgroundColor: Color(pokemonController.typeColors[weakness] ?? 0xFF78C850),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                )
              ).toList()),

            // Ataques
            _buildAttacksSection(pokemon),

            // Estadísticas
            if (pokemon.stats.isNotEmpty)
              _buildStatsSection(pokemon.stats),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: children,
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildAttacksSection(TeamPokemon pokemon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Ataques',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton.icon(
              onPressed: () => _showEditAttacksDialog(pokemon),
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Editar'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red.shade600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...pokemon.attacks.map((attack) => Container(
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 4),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.red.shade200),
          ),
          child: Text(
            attack,
            style: TextStyle(
              fontSize: 14,
              color: Colors.red.shade700,
            ),
          ),
        )).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildStatsSection(Map<String, int> stats) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Estadísticas',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        ...stats.entries.map((stat) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  stat.key.replaceAll('-', ' ').toUpperCase(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                ),
              ),
              Expanded(
                flex: 3,
                child: LinearProgressIndicator(
                  value: stat.value / 255, // Normalizar a 255 (máximo stat)
                  backgroundColor: Colors.grey.shade300,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.red.shade400),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${stat.value}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        )).toList(),
      ],
    );
  }

  void _showClearTeamDialog(BuildContext context) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar'),
        content: const Text('¿Estás seguro de que quieres eliminar todos los Pokémon del equipo?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              teamController.clearTeam();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar Todo', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showRemovePokemonDialog(TeamPokemon pokemon) {
    Get.dialog(
      AlertDialog(
        title: const Text('Confirmar'),
        content: Text('¿Quieres eliminar a ${pokemon.name} del equipo?'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              teamController.removeFromTeam(pokemon.id);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Eliminar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showEditAttacksDialog(TeamPokemon pokemon) {
    final List<TextEditingController> controllers = pokemon.attacks
        .map((attack) => TextEditingController(text: attack))
        .toList();

    // Asegurar que tengamos al menos 4 controladores
    while (controllers.length < 4) {
      controllers.add(TextEditingController());
    }

    Get.dialog(
      AlertDialog(
        title: Text('Editar ataques de ${pokemon.name}'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: controllers.asMap().entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: TextField(
                  controller: entry.value,
                  decoration: InputDecoration(
                    labelText: 'Ataque ${entry.key + 1}',
                    border: const OutlineInputBorder(),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              final newAttacks = controllers
                  .map((controller) => controller.text.trim())
                  .where((attack) => attack.isNotEmpty)
                  .toList();
              
              Get.back();
              teamController.updatePokemonAttacks(pokemon.id, newAttacks);
            },
            child: const Text('Guardar'),
          ),
        ],
      ),
    );
  }
}