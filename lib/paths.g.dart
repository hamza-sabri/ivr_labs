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
      exp_link: fields[2] as String,
      report_link: fields[3] as String,
      video_link: fields[4] as String,
    )
      ..exp_path = fields[5] as String
      ..report_path = fields[6] as String;
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
      ..write(obj.exp_link)
      ..writeByte(3)
      ..write(obj.report_link)
      ..writeByte(4)
      ..write(obj.video_link)
      ..writeByte(5)
      ..write(obj.exp_path)
      ..writeByte(6)
      ..write(obj.report_path);
  }
}
