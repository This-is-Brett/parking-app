import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const ParkingApp());
}

class ParkingApp extends StatelessWidget {
  const ParkingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Parking App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
      ),
      home: const HomeScreen(),
    );
  }
}

/* ============================
   DATA MODEL
============================ */

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

/* ============================
   HOME SCREEN
============================ */

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

/* ============================
   ACTIVE PARKING SCREEN
============================ */

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

/* ============================
   HISTORY SCREEN
============================ */

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    if (parkingHistory.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Parking History'),
        ),
        body: const Center(
          child: Text(
            'No parking history yet.',
            style: TextStyle(fontSize: 18),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking History'),
      ),
      body: ListView.builder(
  padding: const EdgeInsets.only(top: 8, bottom: 20),
        itemCount: parkingHistory.length,
        itemBuilder: (context, index) {
          final session =
              parkingHistory[index];

          return Card(
  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
  elevation: 3,
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Row(
      children: [
        const Icon(
          Icons.local_parking,
          size: 32,
          color: Colors.indigo,
        ),
        const SizedBox(width: 16),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${session.start.hour}:${session.start.minute.toString().padLeft(2,'0')} → "
                "${session.end.hour}:${session.end.minute.toString().padLeft(2,'0')}",
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    Text(
  "Duration: ${session.duration.inMinutes} minutes",
  style: const TextStyle(color: Colors.grey),
),

const SizedBox(height: 6),

if (session.level != null ||
    session.row != null ||
    session.spot != null)
  Row(
    children: [
      const Icon(
        Icons.location_on,
        size: 16,
        color: Color.fromARGB(255, 184, 15, 2),
      ),
      const SizedBox(width: 4),
      Text(
        "${session.level ?? "-"} • ${session.row ?? "-"} • ${session.spot ?? "-"}",
        style: const TextStyle(
          fontSize: 13,
          color: Colors.grey,
        ),
      ),
    ],
  ),

  ],
),
              
            ],
          ),
        ),

        Text(
          "${session.start.day}/${session.start.month}",
          style: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);
        },
      ),
    );
  }
}

/* ============================
   PARKING DETAILS SCREEN
============================ */

class ParkingDetailsScreen extends StatefulWidget {
  const ParkingDetailsScreen({super.key});

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