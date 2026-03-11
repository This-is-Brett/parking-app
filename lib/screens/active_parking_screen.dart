import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../models/parking_session.dart';
import '../services/notification_service.dart';

class ActiveParkingScreen extends StatefulWidget {

  final DateTime startTime;
  final Duration? parkingLimit;

  final String? level;
  final String? row;
  final String? spot;

  final double? latitude;
  final double? longitude;

  const ActiveParkingScreen({
    super.key,
    required this.startTime,
    this.parkingLimit,
    this.level,
    this.row,
    this.spot,
    this.latitude,
    this.longitude,
  });

  @override
  State<ActiveParkingScreen> createState() => _ActiveParkingScreenState();
}

class _ActiveParkingScreenState extends State<ActiveParkingScreen> {

  Timer? _timer;

  Duration _remaining = Duration.zero;

  double progress = 1.0;

  bool warningSent = false;

  @override
  void initState() {
    super.initState();

    if (widget.parkingLimit != null) {
      _remaining = widget.parkingLimit!;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) => _updateTimer(),
    );
  }

  /// =========================
  /// TIMER UPDATE
  /// =========================

  void _updateTimer() {

    if (widget.parkingLimit == null) return;

    final elapsed = DateTime.now().difference(widget.startTime);

    final remaining = widget.parkingLimit! - elapsed;

    setState(() {

      _remaining = remaining.isNegative ? Duration.zero : remaining;

      progress =
          _remaining.inSeconds / widget.parkingLimit!.inSeconds;

      progress = progress.clamp(0.0, 1.0);

      /// 5 minute warning
      final trigger =
          widget.parkingLimit! - const Duration(minutes: 5);

      if (elapsed >= trigger && !warningSent) {

        warningSent = true;

        NotificationService.showWarning();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  /// =========================
  /// FORMAT TIME
  /// =========================

  String _formatRemaining(Duration d) {

    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);

    if (hours > 0) {
      return "${hours}h ${minutes.toString().padLeft(2,'0')}m ${seconds.toString().padLeft(2,'0')}s";
    }

    if (minutes > 0) {
      return "${minutes}m ${seconds.toString().padLeft(2,'0')}s";
    }

    return "${seconds}s";
  }

  /// =========================
  /// STOP PARKING
  /// =========================

  void _stopParking() {

    final end = DateTime.now();

    Hive.box<ParkingSession>('parking_history').add(
      ParkingSession(
        start: widget.startTime,
        end: end,
        level: widget.level,
        row: widget.row,
        spot: widget.spot,
        latitude: widget.latitude,
        longitude: widget.longitude,
      ),
    );

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  /// =========================
  /// UI
  /// =========================

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Active'),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              /// =========================
              /// BIG TIMER RING
              /// =========================

              SizedBox(
                width: 300,
                height: 300,
                child: Stack(
                  alignment: Alignment.center,
                  children: [

                    SizedBox(
                      width: 300,
                      height: 300,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 14,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          _remaining.inSeconds <= 300
                              ? Colors.red
                              : Colors.indigo,
                        ),
                      ),
                    ),

                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        const Text(
                          "Remaining",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),

                        const SizedBox(height: 8),

                        Text(
                          _formatRemaining(_remaining),
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              /// =========================
              /// MINI MAP
              /// =========================

              if (widget.latitude != null && widget.longitude != null)
                Container(
                  height: 150,
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(widget.latitude!, widget.longitude!),
                      zoom: 17,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId("parked_car"),
                        position: LatLng(widget.latitude!, widget.longitude!),
                      )
                    },
                    zoomControlsEnabled: false,
                    myLocationEnabled: false,
                    compassEnabled: false,
                  ),
                ),

              const SizedBox(height: 20),

              /// =========================
              /// NAVIGATE BUTTON
              /// =========================

              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.navigation),
                label: const Text("Navigate to Car"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade200,
                  foregroundColor: Colors.indigo,
                ),
              ),

              const SizedBox(height: 30),

              /// =========================
              /// STOP PARKING BUTTON
              /// =========================

              SizedBox(
                width: 220,
                height: 55,
                child: ElevatedButton(
                  onPressed: _stopParking,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: const Text(
                    "Stop Parking",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}