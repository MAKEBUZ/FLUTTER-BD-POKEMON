import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/favorite_pokemon.dart';
import '../models/custom_move.dart';
import '../models/pokemon_custom_moves.dart';
import '../services/custom_moves_service.dart';

class EditMovesView extends StatefulWidget {
  final FavoritePokemon pokemon;

  const EditMovesView({super.key, required this.pokemon});

  @override
  State<EditMovesView> createState() => _EditMovesViewState();
}

class _EditMovesViewState extends State<EditMovesView> {
  final CustomMovesService _customMovesService = CustomMovesService();
  PokemonCustomMoves? pokemonMoves;
  bool isLoading = true;

  // Controladores para el formulario de nuevo ataque
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String selectedType = 'Normal';
  int selectedPower = 50;
  int selectedAccuracy = 100;

  // Lista de tipos de Pokémon
  final List<String> pokemonTypes = [
    'Normal', 'Fire', 'Water', 'Electric', 'Grass', 'Ice',
    'Fighting', 'Poison', 'Ground', 'Flying', 'Psychic', 'Bug',
    'Rock', 'Ghost', 'Dragon', 'Dark', 'Steel', 'Fairy'
  ];

  // Colores para los tipos
  final Map<String, Color> typeColors = {
    'Normal': const Color(0xFFA8A878),
    'Fire': const Color(0xFFF08030),
    'Water': const Color(0xFF6890F0),
    'Electric': const Color(0xFFF8D030),
    'Grass': const Color(0xFF78C850),
    'Ice': const Color(0xFF98D8D8),
    'Fighting': const Color(0xFFC03028),
    'Poison': const Color(0xFFA040A0),
    'Ground': const Color(0xFFE0C068),
    'Flying': const Color(0xFFA890F0),
    'Psychic': const Color(0xFFF85888),
    'Bug': const Color(0xFFA8B820),
    'Rock': const Color(0xFFB8A038),
    'Ghost': const Color(0xFF705898),
    'Dragon': const Color(0xFF7038F8),
    'Dark': const Color(0xFF705848),
    'Steel': const Color(0xFFB8B8D0),
    'Fairy': const Color(0xFFEE99AC),
  };

  @override
  void initState() {
    super.initState();
    _loadPokemonMoves();
  }

  Future<void> _loadPokemonMoves() async {
    try {
      await _customMovesService.initializePokemonCustomMoves(widget.pokemon);
      final moves = await _customMovesService.getPokemonCustomMoves(widget.pokemon.id);
      setState(() {
        pokemonMoves = moves;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      Get.snackbar('Error', 'No se pudieron cargar los ataques: $e');
    }
  }

  Future<void> _addCustomMove() async {
    if (_nameController.text.trim().isEmpty) {
      Get.snackbar('Error', 'El nombre del ataque es requerido');
      return;
    }

    try {
      final customMove = CustomMove.create(
        name: _nameController.text.trim(),
        type: selectedType,
        power: selectedPower,
        accuracy: selectedAccuracy,
        description: _descriptionController.text.trim(),
      );

      await _customMovesService.addCustomMoveToPokemon(
        widget.pokemon.id,
        widget.pokemon.name,
        customMove,
      );

      // Limpiar formulario
      _nameController.clear();
      _descriptionController.clear();
      selectedType = 'Normal';
      selectedPower = 50;
      selectedAccuracy = 100;

      // Recargar datos
      await _loadPokemonMoves();

      Get.snackbar(
        'Éxito',
        'Ataque personalizado agregado',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'No se pudo agregar el ataque: $e');
    }
  }

  Future<void> _removeCustomMove(int index) async {
    try {
      await _customMovesService.removeCustomMoveFromPokemon(widget.pokemon.id, index);
      await _loadPokemonMoves();
      
      Get.snackbar(
        'Éxito',
        'Ataque personalizado eliminado',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar('Error', 'No se pudo eliminar el ataque: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Editar Ataques - ${widget.pokemon.name}'),
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Información del Pokémon
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Image.network(
                            widget.pokemon.imageUrl,
                            width: 80,
                            height: 80,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.broken_image, size: 80);
                            },
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  widget.pokemon.name.toUpperCase(),
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Wrap(
                                  spacing: 4,
                                  children: widget.pokemon.types.map((type) {
                                    return Chip(
                                      label: Text(
                                        type,
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                        ),
                                      ),
                                      backgroundColor: typeColors[type] ?? Colors.grey,
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Ataques originales
                  const Text(
                    'Ataques Originales',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: pokemonMoves?.originalMoves.map((move) {
                          return ListTile(
                            leading: const Icon(Icons.flash_on, color: Colors.blue),
                            title: Text(move),
                            subtitle: const Text('Ataque original'),
                          );
                        }).toList() ?? [],
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Ataques personalizados
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Ataques Personalizados',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      ElevatedButton.icon(
                        onPressed: _showAddMoveDialog,
                        icon: const Icon(Icons.add),
                        label: const Text('Agregar'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  
                  if (pokemonMoves?.customMoves.isEmpty ?? true)
                    const Card(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'No hay ataques personalizados.\n¡Agrega algunos!',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    )
                  else
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          children: pokemonMoves!.customMoves.asMap().entries.map((entry) {
                            final index = entry.key;
                            final move = entry.value;
                            return ListTile(
                              leading: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: typeColors[move.type] ?? Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Icon(Icons.star, color: Colors.white, size: 20),
                              ),
                              title: Text(move.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tipo: ${move.type} | Poder: ${move.power} | Precisión: ${move.accuracy}%'),
                                  if (move.description.isNotEmpty)
                                    Text(move.description, style: const TextStyle(fontStyle: FontStyle.italic)),
                                ],
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _showDeleteConfirmation(index, move.name),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                ],
              ),
            ),
    );
  }

  void _showAddMoveDialog() {
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: const Text('Agregar Ataque Personalizado'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nombre del ataque',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                
                DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Tipo',
                    border: OutlineInputBorder(),
                  ),
                  items: pokemonTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Row(
                        children: [
                          Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: typeColors[type],
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(type),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setDialogState(() {
                      selectedType = value!;
                    });
                  },
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Poder: $selectedPower'),
                          Slider(
                            value: selectedPower.toDouble(),
                            min: 10,
                            max: 150,
                            divisions: 14,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedPower = value.round();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Precisión: $selectedAccuracy%'),
                          Slider(
                            value: selectedAccuracy.toDouble(),
                            min: 50,
                            max: 100,
                            divisions: 10,
                            onChanged: (value) {
                              setDialogState(() {
                                selectedAccuracy = value.round();
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descripción (opcional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                _addCustomMove();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              child: const Text('Agregar'),
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteConfirmation(int index, String moveName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: Text('¿Estás seguro de que quieres eliminar el ataque "$moveName"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _removeCustomMove(index);
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

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}