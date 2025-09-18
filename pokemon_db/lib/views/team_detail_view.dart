import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/team_controller.dart';
import '../controllers/pokemon_controller.dart';
import '../models/team_pokemon_model.dart';

class TeamDetailView extends StatefulWidget {
  const TeamDetailView({super.key});

  @override
  State<TeamDetailView> createState() => _TeamDetailViewState();
}

class _TeamDetailViewState extends State<TeamDetailView> {
  final TeamController teamController = Get.find<TeamController>();
  final PokemonController pokemonController = Get.find<PokemonController>();
  
  late TeamPokemon pokemon;
  final List<TextEditingController> moveControllers = [];
  final List<String> availableMoves = [
    'Tackle', 'Scratch', 'Growl', 'Leer', 'Ember', 'Water Gun',
    'Vine Whip', 'Thunder Shock', 'Psychic', 'Ice Beam', 'Flamethrower',
    'Surf', 'Earthquake', 'Shadow Ball', 'Dragon Pulse', 'Hyper Beam',
    'Solar Beam', 'Thunder', 'Blizzard', 'Fire Blast', 'Hydro Pump',
    'Leaf Storm', 'Focus Blast', 'Energy Ball', 'Aura Sphere',
    'Dark Pulse', 'Flash Cannon', 'Stone Edge', 'Close Combat',
    'Outrage', 'Meteor Mash', 'Overheat', 'Leaf Blade', 'Crunch',
    'Iron Head', 'Zen Headbutt', 'U-turn', 'Volt Switch', 'Roost',
    'Recover', 'Synthesis', 'Rest', 'Sleep Talk', 'Protect'
  ];

  @override
  void initState() {
    super.initState();
    pokemon = Get.arguments as TeamPokemon;
    
    // Inicializar controladores de movimientos
    for (int i = 0; i < 4; i++) {
      final move = i < pokemon.moves.length ? pokemon.moves[i] : '';
      moveControllers.add(TextEditingController(text: move));
    }
  }

  @override
  void dispose() {
    for (final controller in moveControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          pokemon.name,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: Color(pokemonController.typeColors[pokemon.types.first] ?? 0xFFFF5252),
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _saveMoves,
            icon: const Icon(Icons.save, color: Colors.white),
            tooltip: 'Guardar movimientos',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(pokemonController.typeColors[pokemon.types.first] ?? 0xFFFF5252).withOpacity(0.3),
              Colors.red.shade200.withOpacity(0.1),
              Colors.white,
              Colors.white,
            ],
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Información básica del Pokémon
                _buildPokemonInfo(),
                const SizedBox(height: 24),
                
                // Tipos
                _buildTypesSection(),
                const SizedBox(height: 24),
                
                // Debilidades
                _buildWeaknessesSection(),
                const SizedBox(height: 24),
                
                // Movimientos editables
                _buildMovesSection(),
                const SizedBox(height: 24),
                
                // Información adicional
                _buildAdditionalInfo(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPokemonInfo() {
    return Card(
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.white,
              Colors.red.shade50,
            ],
          ),
        ),
        child: Column(
          children: [
            // ID y nombre
            Text(
              '#${pokemon.id} - ${pokemon.name}',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Imagen
            Hero(
              tag: 'team-pokemon-${pokemon.id}',
              child: Container(
                width: 150,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.red.shade100,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Image.network(
                    pokemon.imageUrl,
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, loadingProgress) {
                      if (loadingProgress == null) return child;
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.catching_pokemon,
                        size: 80,
                        color: Colors.red.shade400,
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tipos:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: pokemon.types.map((type) {
                return Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Color(pokemonController.typeColors[type] ?? 0xFF78C850),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Text(
                    type,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeaknessesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Debilidades:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            pokemon.weaknesses.isEmpty
                ? const Text(
                    'No se encontraron debilidades específicas',
                    style: TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey,
                    ),
                  )
                : Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: pokemon.weaknesses.map((weakness) {
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: Color(pokemonController.typeColors[weakness] ?? 0xFF78C850),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.red.shade300, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Text(
                          weakness,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildMovesSection() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Movimientos:',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton.icon(
                  onPressed: _showMoveSelector,
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Text(
              'Máximo 4 movimientos:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 16),
            ...List.generate(4, (index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: moveControllers[index],
                        decoration: InputDecoration(
                          labelText: 'Movimiento ${index + 1}',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          suffixIcon: moveControllers[index].text.isNotEmpty
                              ? IconButton(
                                  onPressed: () {
                                    setState(() {
                                      moveControllers[index].clear();
                                    });
                                  },
                                  icon: const Icon(Icons.clear),
                                )
                              : null,
                        ),
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () => _showMoveSelector(index),
                      icon: const Icon(Icons.search),
                      tooltip: 'Buscar movimiento',
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _saveMoves,
                icon: const Icon(Icons.save),
                label: const Text('Guardar Movimientos'),
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
    );
  }

  Widget _buildAdditionalInfo() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Información Adicional:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _buildInfoRow('Agregado al equipo:', _formatDate(pokemon.addedAt)),
            _buildInfoRow('Movimientos configurados:', '${pokemon.moves.length}/4'),
            _buildInfoRow('ID del Pokémon:', '#${pokemon.id}'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showMoveSelector([int? index]) {
    Get.dialog(
      AlertDialog(
        title: Text('Seleccionar Movimiento${index != null ? ' ${index + 1}' : ''}'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: ListView.builder(
            itemCount: availableMoves.length,
            itemBuilder: (context, i) {
              final move = availableMoves[i];
              return ListTile(
                title: Text(move),
                onTap: () {
                  if (index != null) {
                    setState(() {
                      moveControllers[index].text = move;
                    });
                  } else {
                    // Buscar el primer slot vacío
                    for (int j = 0; j < 4; j++) {
                      if (moveControllers[j].text.isEmpty) {
                        setState(() {
                          moveControllers[j].text = move;
                        });
                        break;
                      }
                    }
                  }
                  Get.back();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancelar'),
          ),
        ],
      ),
    );
  }

  void _saveMoves() {
    final moves = moveControllers
        .map((controller) => controller.text.trim())
        .where((move) => move.isNotEmpty)
        .toList();

    teamController.updatePokemonMoves(pokemon.id, moves);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}';
  }
}