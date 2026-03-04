import 'package:flutter/material.dart';
import '../models/parking_session.dart';

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

          final session = parkingHistory[index];

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
                                color: Colors.red,
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