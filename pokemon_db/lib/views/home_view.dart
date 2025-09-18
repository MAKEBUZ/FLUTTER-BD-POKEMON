import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pokemon_controller.dart';
import 'pokemon_detail_view.dart';

class HomeView extends StatelessWidget {
  final PokemonController controller = Get.put(PokemonController());
  final TextEditingController searchController = TextEditingController();

  HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pokédex'),
        centerTitle: true,
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
                        ),
                      ],
                    ),
                  );
                }
                
                // Mostrar resultado de la búsqueda
                if (controller.pokemon.value != null) {
                  final pokemon = controller.pokemon.value!;
                  return GestureDetector(
                    onTap: () {
                      Get.to(() => PokemonDetailView(pokemon: pokemon));
                    },
                    child: Card(
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
                              '#${pokemon.id} - ${pokemon.name}',
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 20),
                            
                            // Imagen
                            Hero(
                              tag: 'pokemon-${pokemon.id}',
                              child: Image.network(
                                pokemon.imageUrl,
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
                              children: pokemon.types
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
                            
                            const SizedBox(height: 10),
                            const Text(
                              'Toca para ver más detalles',
                              style: TextStyle(color: Colors.white70),
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