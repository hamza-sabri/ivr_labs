// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paths.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PathsAdapter extends TypeAdapter<Paths> {
  @override
  Paths read(BinaryReader reader) {
    var numOfFields = reader.readByte();
    var fields = <int, dynamic>{
      for (var i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Paths(
      expName: fields[0] as String,
      expNumber: fields[1] as String,
      expLink: fields[2] as String,
      reportLink: fields[3] as String,
      videoLink: fields[4] as String,
    )
      ..expPath = fields[5] as String
      ..reportPath = fields[6] as String;
  }

  @override
  void write(BinaryWriter writer, Paths obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.expName)
      ..writeByte(1)
      ..write(obj.expNumber)
      ..writeByte(2)
      ..write(obj.expLink)
      ..writeByte(3)
      ..write(obj.reportLink)
      ..writeByte(4)
      ..write(obj.videoLink)
      ..writeByte(5)
      ..write(obj.expPath)
      ..writeByte(6)
      ..write(obj.reportPath);
  }
}
