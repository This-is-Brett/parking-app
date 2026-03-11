import 'package:flutter/material.dart';
import 'history_screen.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
      ),
      body: ListView(
        children: [

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Parking History"),
            subtitle: const Text("View past parking sessions"),
            trailing: const Icon(Icons.chevron_right),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HistoryScreen(),
                ),
              );
            },
          ),

          const Divider(),

          ListTile(
            leading: const Icon(Icons.timer),
            title: const Text("Default Parking Time"),
            subtitle: const Text("Coming soon"),
          ),

          ListTile(
            leading: const Icon(Icons.notifications),
            title: const Text("Warning Notifications"),
            subtitle: const Text("Coming soon"),
          ),

          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text("Dark Mode"),
            subtitle: const Text("Coming soon"),
          ),

        ],
      ),
    );
  }
}