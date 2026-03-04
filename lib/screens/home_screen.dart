import 'package:flutter/material.dart';
import 'active_parking_screen.dart';
import 'history_screen.dart';
import 'parking_details_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  void _showParkingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add Parking Details"),
          content: const Text(
            "Would you like to add details about your parking spot?",
          ),
          actions: [
            TextButton(
              child: const Text("Skip"),
              onPressed: () {
                Navigator.pop(context);

                final now = DateTime.now();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ActiveParkingScreen(startTime: now),
                  ),
                );
              },
            ),
            TextButton(
              child: const Text("Add Details"),
              onPressed: () {
                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const ParkingDetailsScreen(),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  textStyle: const TextStyle(fontSize: 18),
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                onPressed: () => _showParkingDialog(context),
                child: const Text('Park Now'),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: 200,
              height: 35,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo[100],
                  foregroundColor: Colors.indigo[800],
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          const HistoryScreen(),
                    ),
                  );
                },
                child: const Text('View History'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}