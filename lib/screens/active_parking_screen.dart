import 'package:flutter/material.dart';
import 'dart:async';
import '../models/parking_session.dart';



class ActiveParkingScreen extends StatefulWidget {
  final DateTime startTime;

  final String? level;
  final String? row;
  final String? spot;

  const ActiveParkingScreen({
    super.key,
    required this.startTime,
    this.level,
    this.row,
    this.spot,
  });

  @override
  State<ActiveParkingScreen> createState() =>
      _ActiveParkingScreenState();
}

class _ActiveParkingScreenState
    extends State<ActiveParkingScreen> {
  late Timer _timer;
  Duration _elapsed = Duration.zero;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (_) {
        setState(() {
          _elapsed =
              DateTime.now().difference(widget.startTime);
        });
      },
    );
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String _formatDuration(Duration d) {
    final hours =
        d.inHours.toString().padLeft(2, '0');
    final minutes =
        d.inMinutes.remainder(60).toString().padLeft(2, '0');
    if (hours == 0) return "${minutes}m";

    return "$hours:$minutes";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking Active'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              "Started at: ${widget.startTime.hour}:${widget.startTime.minute.toString().padLeft(2, '0')}",
              style:
                  const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            Text(
              _formatDuration(_elapsed),
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                final end = DateTime.now();

                parkingHistory.insert (0,
                  ParkingSession(
                    start: widget.startTime,
                    end: end,
                    level: widget.level,
                    row: widget.row,
                    spot: widget.spot,
                  ),
                );

                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text("Stop Parking"),
            ),
          ],
        ),
      ),
    );
  }
}