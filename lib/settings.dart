// settings_page.dart
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _tempController = TextEditingController();
  final _humidityController = TextEditingController();
  bool _notificationsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _tempController.text = prefs.getInt('warningTemp')?.toString() ?? '';
      _humidityController.text =
          prefs.getInt('warningHumidity')?.toString() ?? '';
      _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? false;
    });
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('warningTemp', int.parse(_tempController.text));
    await prefs.setInt('warningHumidity', int.parse(_humidityController.text));
    await prefs.setBool('notificationsEnabled', _notificationsEnabled);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Configurações salvas com sucesso!')),
    );
    Future.delayed(Duration(milliseconds: 700), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _tempController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Temperatura de Aviso',
                hintText: '00',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,2}$')),
              ],
            ),
            SizedBox(height: 16),
            TextField(
              controller: _humidityController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Umidade de Aviso',
                hintText: '00',
                border: OutlineInputBorder(),
              ),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'^[0-9]{1,2}$')),
              ],
            ),
            SizedBox(height: 16),
            CheckboxListTile(
              title: Text('Receber notificações'),
              value: _notificationsEnabled,
              onChanged: (bool? value) {
                setState(() {
                  _notificationsEnabled = value ?? false;
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: _saveSettings,
              child: Text('Salvar Configurações'),
            ),
          ],
        ),
      ),
    );
  }
}
