import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/parking_session.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  Future<void> _openMap(double lat, double lon) async {
    final url = Uri.parse("https://maps.apple.com/?daddr=$lat,$lon");

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box<ParkingSession>('parking_history');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Parking History'),
      ),

      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box<ParkingSession> box, _) {

          if (box.isEmpty) {
            return const Center(
              child: Text(
                'No parking history yet.',
                style: TextStyle(fontSize: 18),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 20),
            itemCount: box.length,
            itemBuilder: (context, index) {

              final session = box.getAt(index)!;

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

                            /// Start → End
                            Text(
                              "${session.start.hour}:${session.start.minute.toString().padLeft(2,'0')} → "
                              "${session.end.hour}:${session.end.minute.toString().padLeft(2,'0')}",
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 4),

                            /// Duration
                            Text(
                              "Duration: ${session.duration.inMinutes} minutes",
                              style: const TextStyle(color: Colors.grey),
                            ),

                            const SizedBox(height: 6),

                            /// Parking spot info
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

                            /// Navigate to car
                            if (session.latitude != null &&
                                session.longitude != null)

                              GestureDetector(
                                onTap: () {
                                  _openMap(
                                    session.latitude!,
                                    session.longitude!,
                                  );
                                },

                                child: const Padding(
                                  padding: EdgeInsets.only(top: 6),
                                  child: Text(
                                    "📍 Navigate to car",
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.indigo,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),

                      /// Date
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
          );
        },
      ),
    );
  }
}