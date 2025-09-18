import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pokemon_controller.dart';
import '../controllers/team_controller.dart';
import 'pokemon_detail_view.dart';
import 'team_view.dart';

class HomeView extends StatelessWidget {
  final PokemonController controller = Get.put(PokemonController());
  final TeamController teamController = Get.put(TeamController());
  final TextEditingController searchController = TextEditingController();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
        actions: [
          // Botón para ir a la vista de equipo
          IconButton(
            onPressed: () => Get.to(() => TeamView()),
            icon: const Icon(Icons.group),
            tooltip: 'Ver Equipo',
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de búsqueda
            TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar por nombre o número',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    searchController.clear();
                    controller.clearSearch();
                  },
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onSubmitted: (value) {
                if (value.isNotEmpty) {
                  controller.searchPokemon(value);
                }
              },
            ),
            const SizedBox(height: 20),
            
            // Mostrar resultados o mensajes
            Expanded(
              child: Obx(() {
                // Mostrar indicador de carga
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                // Mostrar mensaje de error
                if (controller.error.value.isNotEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.red),
                        const SizedBox(height: 16),
                        Text(
                          controller.error.value,
                          textAlign: TextAlign.center,
                          style: const TextStyle(fontSize: 18),
                        ],
                      ),
                    ),
                  );
                }
                
                // Mostrar resultado de la búsqueda
                if (controller.pokemon.value != null) {
                  return Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(controller.getBackgroundColor()).withOpacity(0.7),
                            Color(controller.getBackgroundColor()),
                          ],
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                            // ID y nombre
                            Text(
                              '#${controller.pokemon.value!.id} - ${controller.pokemon.value!.name}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Imagen
                            Hero(
                              tag: 'pokemon-${controller.pokemon.value!.id}',
                              child: Image.network(
                                controller.pokemon.value!.imageUrl,
                                height: 200,
                                fit: BoxFit.contain,
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) return child;
                                  return const Center(child: CircularProgressIndicator());
                                },
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.broken_image, size: 100);
                                },
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Tipos
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: controller.pokemon.value!.types
                                  .map((type) => Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 5),
                                        child: Chip(
                                          label: Text(
                                            type,
                                            style: const TextStyle(color: Colors.white),
                                          ),
                                          backgroundColor: Color(controller.typeColors[type] ?? 0xFF78C850),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            const SizedBox(height: 20),
                            
                            // Botones de acción
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                // Botón Favorito (Agregar al equipo)
                                Obx(() => ElevatedButton.icon(
                                  onPressed: teamController.isInTeam(controller.pokemon.value!.id)
                                      ? null
                                      : () async {
                                          final success = await teamController.addPokemon(controller.pokemon.value!);
                                          if (success) {
                                            Get.snackbar(
                                              'Éxito',
                                              '${controller.pokemon.value!.name} agregado al equipo',
                                              backgroundColor: Colors.green,
                                              colorText: Colors.white,
                                              snackPosition: SnackPosition.BOTTOM,
                                            );
                                          }
                                        },
                                  icon: Icon(
                                    teamController.isInTeam(controller.pokemon.value!.id)
                                        ? Icons.favorite
                                        : Icons.favorite_border,
                                  ),
                                  label: Text(
                                    teamController.isInTeam(controller.pokemon.value!.id)
                                        ? 'En Equipo'
                                        : 'Favorito',
                                  ),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: teamController.isInTeam(controller.pokemon.value!.id)
                                        ? Colors.red.shade300
                                        : Colors.red.shade600,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                )),
                                
                                // Botón Ver Detalles
                                ElevatedButton.icon(
                                  onPressed: () => Get.to(() => PokemonDetailView()),
                                  icon: const Icon(Icons.info_outline),
                                  label: const Text('Detalles'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue.shade600,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            
                            const SizedBox(height: 10),
                            const Text(
                              'Agrega a favoritos o ve más detalles',
                              style: TextStyle(color: Colors.white70, fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }
                
                // Estado inicial
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.catching_pokemon, size: 100, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Busca un Pokémon por nombre o número',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}