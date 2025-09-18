import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pokemon_controller.dart';
import '../models/pokemon_model.dart';

class PokemonDetailView extends StatelessWidget {
  final Pokemon pokemon;
  
  const PokemonDetailView({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final PokemonController controller = Get.find<PokemonController>();
    return Scaffold(
        appBar: AppBar(
          title: Text(pokemon.name),
          backgroundColor: Color(controller.getBackgroundColor()),
          actions: [
            // Botón de favorito (estrella)
            Obx(() => IconButton(
              icon: Icon(
                controller.isFavorite.value ? Icons.star : Icons.star_border,
                color: controller.isFavorite.value ? Colors.yellow : Colors.white,
                size: 28,
              ),
              onPressed: controller.toggleFavorite,
              tooltip: controller.isFavorite.value ? 'Remover del equipo' : 'Agregar al equipo',
            )),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(controller.getBackgroundColor()).withOpacity(0.7),
                Colors.white,
              ],
            ),
          ),
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // ID y nombre
                  Text(
                    '#${pokemon.id} - ${pokemon.name}',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Imagen
                  Hero(
                    tag: 'pokemon-${pokemon.id}',
                    child: Image.network(
                      pokemon.imageUrl,
                      height: 250,
                      fit: BoxFit.contain,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(child: CircularProgressIndicator());
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.broken_image, size: 150);
                      },
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Información
                  Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Tipos
                          const Text(
                            'Tipos:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: pokemon.types
                                .map((type) => Chip(
                                      label: Text(
                                        type,
                                        style: const TextStyle(color: Colors.white),
                                      ),
                                      backgroundColor: Color(controller.typeColors[type] ?? 0xFF78C850),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 20),

                          // Debilidades
                          const Text(
                            'Debilidades:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          pokemon.weaknesses.isEmpty
                              ? const Text('No se encontraron debilidades')
                              : Wrap(
                                  spacing: 8,
                                  runSpacing: 8,
                                  children: pokemon.weaknesses
                                      .map((weakness) => Chip(
                                            label: Text(
                                              weakness,
                                              style: const TextStyle(color: Colors.white),
                                            ),
                                            backgroundColor: Color(controller.typeColors[weakness] ?? 0xFF78C850),
                                          ))
                                      .toList(),
                                ),
                          const SizedBox(height: 20),

                          // Ataques principales
                          const Text(
                            'Ataques Principales:',
                            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          pokemon.moves.isEmpty
                              ? const Text('No se encontraron ataques')
                              : Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: pokemon.moves
                                      .map((move) => Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 4),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.all(12),
                                              decoration: BoxDecoration(
                                                color: Color(controller.getBackgroundColor()).withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(8),
                                                border: Border.all(
                                                  color: Color(controller.getBackgroundColor()).withOpacity(0.3),
                                                ),
                                              ),
                                              child: Text(
                                                '• $move',
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
  }
}