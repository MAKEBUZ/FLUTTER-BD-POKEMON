import 'package:hive/hive.dart';

part 'team_pokemon_model.g.dart';

@HiveType(typeId: 1)
class TeamPokemon extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String imageUrl;

  @HiveField(3)
  final List<String> types;

  @HiveField(4)
  final List<String> weaknesses;

  @HiveField(5)
  final List<String> moves;

  @HiveField(6)
  final DateTime addedAt;

  TeamPokemon({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.types,
    required this.weaknesses,
    required this.moves,
    required this.addedAt,
  });

  // Constructor desde Pokemon regular
  factory TeamPokemon.fromPokemon(dynamic pokemon, {List<String>? customMoves}) {
    return TeamPokemon(
      id: pokemon.id,
      name: pokemon.name,
      imageUrl: pokemon.imageUrl,
      types: List<String>.from(pokemon.types),
      weaknesses: List<String>.from(pokemon.weaknesses),
      moves: customMoves ?? [],
      addedAt: DateTime.now(),
    );
  }

  // Convertir a Map para JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'types': types,
      'weaknesses': weaknesses,
      'moves': moves,
      'addedAt': addedAt.toIso8601String(),
    };
  }

  // Crear desde Map/JSON
  factory TeamPokemon.fromJson(Map<String, dynamic> json) {
    return TeamPokemon(
      id: json['id'],
      name: json['name'],
      imageUrl: json['imageUrl'],
      types: List<String>.from(json['types']),
      weaknesses: List<String>.from(json['weaknesses']),
      moves: List<String>.from(json['moves']),
      addedAt: DateTime.parse(json['addedAt']),
    );
  }

  // Crear copia con modificaciones
  TeamPokemon copyWith({
    int? id,
    String? name,
    String? imageUrl,
    List<String>? types,
    List<String>? weaknesses,
    List<String>? moves,
    DateTime? addedAt,
  }) {
    return TeamPokemon(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
      types: types ?? this.types,
      weaknesses: weaknesses ?? this.weaknesses,
      moves: moves ?? this.moves,
      addedAt: addedAt ?? this.addedAt,
    );
  }

  @override
  String toString() {
    return 'TeamPokemon(id: $id, name: $name, types: $types, moves: ${moves.length})';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is TeamPokemon && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}