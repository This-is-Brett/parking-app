// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'parking_session.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ParkingSessionAdapter extends TypeAdapter<ParkingSession> {
  @override
  final int typeId = 0;

  @override
  ParkingSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ParkingSession(
      start: fields[0] as DateTime,
      end: fields[1] as DateTime,
      level: fields[2] as String?,
      row: fields[3] as String?,
      spot: fields[4] as String?,
      latitude: fields[5] as double?,
      longitude: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, ParkingSession obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.start)
      ..writeByte(1)
      ..write(obj.end)
      ..writeByte(2)
      ..write(obj.level)
      ..writeByte(3)
      ..write(obj.row)
      ..writeByte(4)
      ..write(obj.spot)
      ..writeByte(5)
      ..write(obj.latitude)
      ..writeByte(6)
      ..write(obj.longitude);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ParkingSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
