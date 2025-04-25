// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorite_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FavoriteModelAdapter extends TypeAdapter<FavoriteModel> {
  @override
  final int typeId = 1;

  @override
  FavoriteModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteModel(
      id: fields[0] as String,
      type: fields[1] as FavoriteType,
      title: fields[2] as String,
      imageUrl: fields[3] as String,
      price: fields[4] as String,
      city: fields[5] as String,
      additionalInfo: fields[6] as String?,
    );
  }

  @override
void write(BinaryWriter writer, FavoriteModel obj) {
  writer
    ..writeByte(7)  
    ..writeByte(0)
    ..write(obj.id)
    ..writeByte(1)
    ..write(obj.type)
    ..writeByte(2)
    ..write(obj.title)
    ..writeByte(3)
    ..write(obj.imageUrl)
    ..writeByte(4)
    ..write(obj.price)  
    ..writeByte(5)
    ..write(obj.city)   
    ..writeByte(6)
    ..write(obj.additionalInfo);
}

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteTypeAdapter extends TypeAdapter<FavoriteType> {
  @override
  final int typeId = 0;

  @override
  FavoriteType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return FavoriteType.place;
      case 1:
        return FavoriteType.activity;
      case 2:
        return FavoriteType.event;
      default:
        return FavoriteType.place;
    }
  }

  @override
  void write(BinaryWriter writer, FavoriteType obj) {
    switch (obj) {
      case FavoriteType.place:
        writer.writeByte(0);
        break;
      case FavoriteType.activity:
        writer.writeByte(1);
        break;
      case FavoriteType.event:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
