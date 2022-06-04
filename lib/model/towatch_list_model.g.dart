// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'towatch_list_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TowatchListModelAdapter extends TypeAdapter<TowatchListModel> {
  @override
  final int typeId = 1;

  @override
  TowatchListModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TowatchListModel(
      name: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, TowatchListModel obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TowatchListModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
