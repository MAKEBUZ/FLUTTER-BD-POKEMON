import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pokemon_controller.dart';

class PokemonDetailView extends StatelessWidget {
  final PokemonController controller = Get.find<PokemonController>();

  PokemonDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pokemon = controller.pokemon.value;
      if (pokemon == null) return const Scaffold(body: Center(child: Text('No hay datos disponibles')));

      return Scaffold(
        appBar: AppBar(
          title: Text(pokemon.name),
          backgroundColor: Color(controller.getBackgroundColor()),
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
    });
  }
}