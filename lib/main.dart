// main.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  String _temp_limit = '';
  String _hum_limit = '';
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    print(prefs.get('warningTemp'));
    _temp_limit = prefs.getInt('warningTemp')?.toString() ?? '';
    _hum_limit = prefs.getInt('warningHumidity')?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    _loadSettings();
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
      ),
      body: Center(
        child: Column(
          children: [Text(_temp_limit), Text(_hum_limit)],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsPage()),
          );
        },
        child: Icon(Icons.settings),
      ),
    );
  }
}
