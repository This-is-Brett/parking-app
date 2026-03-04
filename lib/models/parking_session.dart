class ParkingSession {
  final DateTime start;
  final DateTime end;

  final String? level;
  final String? row;
  final String? spot;

  ParkingSession({
    required this.start,
    required this.end,
    this.level,
    this.row,
    this.spot,
  });

  Duration get duration => end.difference(start);
}

List<ParkingSession> parkingHistory = [];