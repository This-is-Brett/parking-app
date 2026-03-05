import 'package:flutter/material.dart';
import 'active_parking_screen.dart';

class ParkingDetailsScreen extends StatefulWidget {

  final double? latitude;
  final double? longitude;
  final Duration? parkingLimit;

  const ParkingDetailsScreen({
    super.key,
    this.latitude,
    this.longitude,
    this.parkingLimit,
  });

  @override
  State<ParkingDetailsScreen> createState() =>
      _ParkingDetailsScreenState();
}

class _ParkingDetailsScreenState extends State<ParkingDetailsScreen> {

  final levelController = TextEditingController();
  final rowController = TextEditingController();
  final spotController = TextEditingController();

  @override
  void dispose() {
    levelController.dispose();
    rowController.dispose();
    spotController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking Details"),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [

            TextField(
              controller: levelController,
              decoration: const InputDecoration(
                labelText: "Level",
              ),
            ),

            TextField(
              controller: rowController,
              decoration: const InputDecoration(
                labelText: "Row",
              ),
            ),

            TextField(
              controller: spotController,
              decoration: const InputDecoration(
                labelText: "Spot",
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
  child: const Text("Start Parking"),
  onPressed: () {

    final now = DateTime.now();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveParkingScreen(
          startTime: now,

          level: levelController.text,
          row: rowController.text,
          spot: spotController.text,

          latitude: widget.latitude,
          longitude: widget.longitude,

          parkingLimit: widget.parkingLimit,
        ),
      ),
    );
  },
),

          ],
        ),
      ),
    );
  }
}