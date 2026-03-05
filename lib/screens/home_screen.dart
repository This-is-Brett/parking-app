import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'active_parking_screen.dart';
import 'history_screen.dart';
import 'parking_details_screen.dart';
import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  //// PARKING LIMIT VARIABLES

  Duration? parkingLimit;

  int selectedIndex = 1;

  final limits = [
    const Duration(minutes: 30),
    const Duration(hours: 1),
    const Duration(hours: 2),
  ];

  @override
  void initState() {
    super.initState();
    parkingLimit = limits[1];
  }

  //// LOCATION + PARKING FLOW

  Future<void> _showParkingDialog(BuildContext context) async {

    Position? position;

    try {
      position = await LocationService.getLocation();

      print("GPS LAT: ${position.latitude}");
      print("GPS LON: ${position.longitude}");

    } catch (e) {
      position = null;
    }

    showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text("Add Parking Details"),
          content: const Text(
            "Would you like to add details about your parking spot?",
          ),
          actions: [

            //// SKIP DETAILS

            TextButton(
              child: const Text("Skip"),
              onPressed: () {

                Navigator.pop(context);

                final now = DateTime.now();

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ActiveParkingScreen(
                      startTime: now,
                      latitude: position?.latitude,
                      longitude: position?.longitude,
                      parkingLimit: parkingLimit,
                    ),
                  ),
                );
              },
            ),

            //// ADD DETAILS

            TextButton(
              child: const Text("Add Details"),
              onPressed: () {

                Navigator.pop(context);

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ParkingDetailsScreen(
                      latitude: position?.latitude,
                      longitude: position?.longitude,
                      parkingLimit: parkingLimit,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  //// CUSTOM PARKING LIMIT PICKER

  Future<void> _selectCustomLimit() async {

    int hours = 1;
    int minutes = 0;

    await showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text("Custom Parking Time"),

          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              //// HOURS

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text("Hours"),

                  DropdownButton<int>(
                    value: hours,
                    items: List.generate(
                      12,
                      (i) => DropdownMenuItem(
                        value: i,
                        child: Text("$i"),
                      ),
                    ),
                    onChanged: (value) {
                      hours = value!;
                    },
                  ),
                ],
              ),

              //// MINUTES

              Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  const Text("Minutes"),

                  DropdownButton<int>(
                    value: minutes,
                    items: const [

                      DropdownMenuItem(value: 0, child: Text("00")),
                      DropdownMenuItem(value: 15, child: Text("15")),
                      DropdownMenuItem(value: 30, child: Text("30")),
                      DropdownMenuItem(value: 45, child: Text("45")),

                    ],
                    onChanged: (value) {
                      minutes = value!;
                    },
                  ),
                ],
              ),
            ],
          ),

          actions: [

            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.pop(context),
            ),

            TextButton(
              child: const Text("OK"),
              onPressed: () {

                setState(() {

                  parkingLimit = Duration(
                    hours: hours,
                    minutes: minutes,
                  );

                  selectedIndex = 3;

                });

                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  //// LIMIT BUTTON BUILDER

  Widget buildLimitButton(String label, int index, Duration? value) {

    final isSelected = selectedIndex == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {

          if (index == 3) {
            _selectCustomLimit();
            return;
          }

          setState(() {
            selectedIndex = index;
            parkingLimit = value;
          });
        },

        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 12),

          decoration: BoxDecoration(
            color: isSelected ? Colors.indigo : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(10),
          ),

          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //// UI BUILD

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Parking App"),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            //// PARKING LIMIT SELECTOR

            Row(
              children: [

                buildLimitButton("30m", 0, limits[0]),
                buildLimitButton("1h", 1, limits[1]),
                buildLimitButton("2h", 2, limits[2]),
                buildLimitButton("Custom", 3, null),

              ],
            ),

            const SizedBox(height: 40),

            //// PARK NOW BUTTON

            SizedBox(
              width: double.infinity,
              height: 55,

              child: ElevatedButton(
                onPressed: () => _showParkingDialog(context),

                child: const Text(
                  "Park Now",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),

            const SizedBox(height: 20),

            //// HISTORY BUTTON

            SizedBox(
              width: double.infinity,
              height: 45,

              child: OutlinedButton(
                onPressed: () {

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HistoryScreen(),
                    ),
                  );
                },

                child: const Text("View History"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}