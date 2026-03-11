import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';

import '../services/location_service.dart';
import 'active_parking_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  bool isFreeVersion = true;

  GoogleMapController? _mapController;

  String selectedTime = "1h";
  Duration customDuration = const Duration(hours: 1);

  double? currentLatitude;
  double? currentLongitude;

  final Set<Marker> _markers = {};

  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  /// LOAD LOCATION
  Future<void> _loadLocation() async {

    final pos = await LocationService.getCurrentLocation();

    if (pos != null) {

      setState(() {

        currentLatitude = pos.latitude;
        currentLongitude = pos.longitude;

        _markers.add(
          Marker(
            markerId: const MarkerId("parking_location"),
            position: LatLng(pos.latitude, pos.longitude),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueRed,
            ),
          ),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [

          Expanded(
            child: Stack(
              children: [

                /// MAP
                Positioned.fill(
                  child: GoogleMap(
                    initialCameraPosition: const CameraPosition(
                      target: LatLng(51.0, 9.0),
                      zoom: 15,
                    ),
                    myLocationEnabled: true,
                    myLocationButtonEnabled: false,
                    zoomControlsEnabled: false,
                    markers: _markers,
                    onMapCreated: (controller) {
                      _mapController = controller;
                    },
                  ),
                ),

                /// FLOATING HEADER
Positioned(
  top: 0,
  left: 0,
  right: 0,
  child: SafeArea(
    child: SizedBox(
      width: double.infinity,
      height: 100,
      child: Stack(
        alignment: Alignment.center,
        children: [

          /// CENTERED LOGO (center of entire screen)
          Center(
            child: Image.asset(
              'assets/logo/logo_horizontal.png',
              height: 100,
              fit: BoxFit.contain,
            ),
          ),

          /// SETTINGS BUTTON (right side)
          Positioned(
            right: 16,
            child: IconButton(
              icon: const Icon(Icons.settings),
              iconSize: 26,
              color: Colors.black87,
              onPressed: () {
                // open settings
              },
            ),
          ),
        ],
      ),
    ),
  ),
),

                /// LOCATION BUTTON
                Positioned(
                  right: 20,
                  bottom: 260,
                  child: FloatingActionButton(
                    mini: true,
                    backgroundColor: Colors.white,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.indigo,
                    ),
                    onPressed: _goToUserLocation,
                  ),
                ),

                /// CONTROL PANEL
                Positioned(
                  left: 16,
                  right: 16,
                  bottom: 80,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.95),
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        Row(
                          children: [
                            Expanded(child: _timeButton("30m")),
                            const SizedBox(width: 8),
                            Expanded(child: _timeButton("1h")),
                            const SizedBox(width: 8),
                            Expanded(child: _timeButton("2h")),
                            const SizedBox(width: 8),
                            Expanded(child: _customButton()),
                          ],
                        ),

                        const SizedBox(height: 16),

                        SizedBox(
                          width: double.infinity,
                          height: 60,
                          child: ElevatedButton(
                            onPressed: _startParking,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4B5CC4),
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16),
                              ),
                            ),
                            child: const Text(
                              "Park Now",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          /// AD BANNER
          if (isFreeVersion)
            Container(
              height: 60,
              width: double.infinity,
              color: Colors.grey.shade300,
              alignment: Alignment.center,
              child: const Text("Ad Banner"),
            ),
        ],
      ),
    );
  }

  /// TIME BUTTON
  Widget _timeButton(String label) {

    bool selected = selectedTime == label;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedTime = label;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4B5CC4) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// CUSTOM BUTTON
  Widget _customButton() {

    bool selected = selectedTime == "custom";

    return GestureDetector(
      onTap: _pickCustomTime,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? const Color(0xFF4B5CC4) : Colors.grey.shade200,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          selected
              ? "${customDuration.inHours}h ${(customDuration.inMinutes % 60)}m"
              : "Custom",
          style: TextStyle(
            color: selected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  /// CUSTOM TIMER (FIXED - RESTORED)
  Future<void> _pickCustomTime() async {

    int hours = customDuration.inHours;
    int minutes = customDuration.inMinutes % 60;

    await showDialog(
      context: context,
      builder: (context) {

        return AlertDialog(
          title: const Text("Select parking duration"),

          content: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [

              DropdownButton<int>(
                value: hours,
                items: List.generate(
                  12,
                  (i) => DropdownMenuItem(
                    value: i,
                    child: Text("$i h"),
                  ),
                ),
                onChanged: (v) => hours = v!,
              ),

              DropdownButton<int>(
                value: minutes,
                items: const [
                  DropdownMenuItem(value: 0, child: Text("0 m")),
                  DropdownMenuItem(value: 15, child: Text("15 m")),
                  DropdownMenuItem(value: 30, child: Text("30 m")),
                  DropdownMenuItem(value: 45, child: Text("45 m")),
                ],
                onChanged: (v) => minutes = v!,
              ),
            ],
          ),

          actions: [

            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),

            ElevatedButton(
              onPressed: () {

                setState(() {
                  customDuration = Duration(
                    hours: hours,
                    minutes: minutes,
                  );
                  selectedTime = "custom";
                });

                Navigator.pop(context);
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /// START PARKING
  Future<void> _startParking() async {

    final duration = _getSelectedDuration();

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ActiveParkingScreen(
          startTime: DateTime.now(),
          parkingLimit: duration,
          latitude: currentLatitude,
          longitude: currentLongitude,
        ),
      ),
    );
  }

  Duration _getSelectedDuration() {

    if (selectedTime == "30m") return const Duration(minutes: 30);
    if (selectedTime == "1h") return const Duration(hours: 1);
    if (selectedTime == "2h") return const Duration(hours: 2);
    if (selectedTime == "custom") return customDuration;

    return const Duration(hours: 1);
  }

  Future<void> _goToUserLocation() async {

    if (_mapController == null ||
        currentLatitude == null ||
        currentLongitude == null) return;

    await _mapController!.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLatitude!, currentLongitude!),
          zoom: 16,
        ),
      ),
    );
  }
}