// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_pokemon.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoritePokemonAdapter extends TypeAdapter<FavoritePokemon> {
  @override
  final int typeId = 0;

  @override
  FavoritePokemon read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoritePokemon(
      id: fields[0] as int,
      name: fields[1] as String,
      imageUrl: fields[2] as String,
      types: (fields[3] as List).cast<String>(),
      weaknesses: (fields[4] as List).cast<String>(),
      moves: (fields[5] as List).cast<String>(),
      addedDate: fields[6] as DateTime,
      hasCustomMoves: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, FavoritePokemon obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.imageUrl)
      ..writeByte(3)
      ..write(obj.types)
      ..writeByte(4)
      ..write(obj.weaknesses)
      ..writeByte(5)
      ..write(obj.moves)
      ..writeByte(6)
      ..write(obj.addedDate)
      ..writeByte(7)
      ..write(obj.hasCustomMoves);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoritePokemonAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
