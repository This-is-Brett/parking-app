import 'package:hive/hive.dart';

part 'parking_session.g.dart';

@HiveType(typeId: 0)
class ParkingSession extends HiveObject {

  @HiveField(0)
  final DateTime start;

  @HiveField(1)
  final DateTime end;

  @HiveField(2)
  final String? level;

  @HiveField(3)
  final String? row;

  @HiveField(4)
  final String? spot;

  @HiveField(5)
  final double? latitude;

  @HiveField(6)
  final double? longitude;

  ParkingSession({
  required this.start,
  required this.end,
  this.level,
  this.row,
  this.spot,
  this.latitude,
  this.longitude,
});
 Duration get duration => end.difference(start);
  }

