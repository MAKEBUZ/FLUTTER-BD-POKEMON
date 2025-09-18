class Pokemon {
  final int id;
  final String name;
  final String imageUrl;
  final List<String> types;
  final List<String> weaknesses;
  final List<String> moves; // Nuevos ataques principales

  Pokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.weaknesses,
    required this.moves, // Agregando ataques al constructor
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    // Extraer ID del Pokémon
    final int id = json['id'];
    
    // Extraer nombre y convertir primera letra a mayúscula
    final String name = json['name'].toString().capitalize();
    
    // Obtener URL de la imagen
    final String imageUrl = json['sprites']['other']['official-artwork']['front_default'] ?? 
                           json['sprites']['front_default'] ?? 
                           'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png';
    
    // Extraer tipos
    final List<String> types = (json['types'] as List)
        .map((type) => type['type']['name'].toString().capitalize())
        .toList();
    
    // Extraer ataques principales (primeros 4 movimientos)
    final List<String> moves = [];
    if (json['moves'] != null && json['moves'] is List) {
      final movesList = json['moves'] as List;
      for (int i = 0; i < movesList.length && i < 4; i++) {
        final moveName = movesList[i]['move']['name'].toString().replaceAll('-', ' ').capitalize();
        moves.add(moveName);
      }
    }
    
    // Las debilidades no vienen directamente en la API, se calcularán en el servicio
    // Por ahora dejamos una lista vacía
    final List<String> weaknesses = [];
    
    return Pokemon(
      id: id,
      name: name,
      imageUrl: imageUrl,
      types: types,
      weaknesses: weaknesses,
      moves: moves, // Agregando ataques al return
    );
  }
}

// Extensión para capitalizar strings
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}