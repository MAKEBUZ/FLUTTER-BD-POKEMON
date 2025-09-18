// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_move.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomMoveAdapter extends TypeAdapter<CustomMove> {
  @override
  final int typeId = 1;

  @override
  CustomMove read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomMove(
      name: fields[0] as String,
      type: fields[1] as String,
      power: fields[2] as int,
      accuracy: fields[3] as int,
      description: fields[4] as String,
      createdDate: fields[5] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, CustomMove obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.type)
      ..writeByte(2)
      ..write(obj.power)
      ..writeByte(3)
      ..write(obj.accuracy)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.createdDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomMoveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
