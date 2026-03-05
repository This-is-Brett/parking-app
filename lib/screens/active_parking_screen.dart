import 'package:flutter/material.dart';
import 'dart:async';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/parking_session.dart';
import '../services/notification_service.dart';

class ActiveParkingScreen extends StatefulWidget {
  final DateTime startTime;

  final String? level;
  final String? row;
  final String? spot;

  final double? latitude;
  final double? longitude;

  final Duration? parkingLimit;

  const ActiveParkingScreen({
    super.key,
    required this.startTime,
    this.level,
    this.row,
    this.spot,
    this.latitude,
    this.longitude,
    this.parkingLimit,
  });

  @override
  State<ActiveParkingScreen> createState() => _ActiveParkingScreenState();
}

class _ActiveParkingScreenState extends State<ActiveParkingScreen> {

  late Timer _timer;

  Duration _remaining = Duration.zero;

  bool warningSent = false;

  double progress = 1.0;

  @override
  void initState() {
    super.initState();

    if (widget.parkingLimit != null) {
      _remaining = widget.parkingLimit!;
    }

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {

        setState(() {

          final elapsed =
              DateTime.now().difference(widget.startTime);

          if (widget.parkingLimit != null) {

            _remaining = widget.parkingLimit! - elapsed;

            if (_remaining.isNegative) {
              _remaining = Duration.zero;
            }

            progress =
                _remaining.inSeconds / widget.parkingLimit!.inSeconds;

            /// 5-minute warning notification
            if (_remaining.inMinutes <= 5 && !warningSent) {
              warningSent = true;
              NotificationService.showWarning();
            }
          }
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatRemaining(Duration d) {

    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);

    if (hours > 0) {
      return "${hours}h ${minutes}m";
    }

    return "${minutes}m";
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Active'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
              width: 220,
              height: 220,

              child: Stack(
                alignment: Alignment.center,

                children: [

                  SizedBox(
                    width: 220,
                    height: 220,

                    child: CircularProgressIndicator(
                      value: progress,
                      strokeWidth: 12,
                      backgroundColor: Colors.grey.shade300,

                      valueColor: AlwaysStoppedAnimation<Color>(
                        _remaining.inMinutes <= 5
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
                          fontSize: 16,
                          color: Colors.grey,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        _formatRemaining(_remaining),
                        style: const TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 50),

            ElevatedButton(
              onPressed: () {

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

                Navigator.popUntil(
                    context, (route) => route.isFirst);
              },

              child: const Text("Stop Parking"),
            ),
          ],
        ),
      ),
    );
  }
}