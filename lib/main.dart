import 'package:flutter/material.dart';
import 'screens/home_screen.dart';

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



/* ============================
   HOME SCREEN
============================ */



/* ============================
   ACTIVE PARKING SCREEN
============================ */



/* ============================
   PARKING DETAILS SCREEN
============================ */

