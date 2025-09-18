import 'package:hive/hive.dart';

part 'custom_move.g.dart';

@HiveType(typeId: 1)
class CustomMove extends HiveObject {
  @HiveField(0)
  final String name;

  @HiveField(1)
  final String type;

  @HiveField(2)
  final int power;

  @HiveField(3)
  final int accuracy;

  @HiveField(4)
  final String description;

  @HiveField(5)
  final DateTime createdDate;

  CustomMove({
    required this.name,
    required this.type,
    required this.power,
    required this.accuracy,
    required this.description,
    required this.createdDate,
  });

  // Factory constructor para crear un ataque personalizado
  factory CustomMove.create({
    required String name,
    required String type,
    required int power,
    required int accuracy,
    required String description,
  }) {
    return CustomMove(
      name: name,
      type: type,
      power: power,
      accuracy: accuracy,
      description: description,
      createdDate: DateTime.now(),
    );
  }

  // Convertir a Map para facilitar el manejo
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type,
      'power': power,
      'accuracy': accuracy,
      'description': description,
      'createdDate': createdDate.toIso8601String(),
    };
  }

  @override
  String toString() {
    return 'CustomMove(name: $name, type: $type, power: $power, accuracy: $accuracy)';
  }
}