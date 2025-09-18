// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pokemon_custom_moves.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PokemonCustomMovesAdapter extends TypeAdapter<PokemonCustomMoves> {
  @override
  final int typeId = 2;

  @override
  PokemonCustomMoves read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PokemonCustomMoves(
      pokemonId: fields[0] as int,
      pokemonName: fields[1] as String,
      originalMoves: (fields[2] as List).cast<String>(),
      customMoves: (fields[3] as List).cast<CustomMove>(),
      lastModified: fields[4] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, PokemonCustomMoves obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.pokemonId)
      ..writeByte(1)
      ..write(obj.pokemonName)
      ..writeByte(2)
      ..write(obj.originalMoves)
      ..writeByte(3)
      ..write(obj.customMoves)
      ..writeByte(4)
      ..write(obj.lastModified);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PokemonCustomMovesAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
