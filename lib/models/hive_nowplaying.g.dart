// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_nowplaying.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NowPayingHiveAdapter extends TypeAdapter<NowPayingHive> {
  @override
  final int typeId = 0;

  @override
  NowPayingHive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NowPayingHive(
      movieId: fields[0] as int?,
      title: fields[1] as String?,
      image: fields[2] as String?,
      releaseDate: fields[3] as String?,
      voteAverage: fields[4] as num?,
      overview: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, NowPayingHive obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.movieId)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.image)
      ..writeByte(3)
      ..write(obj.releaseDate)
      ..writeByte(4)
      ..write(obj.voteAverage)
      ..writeByte(5)
      ..write(obj.overview);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NowPayingHiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
