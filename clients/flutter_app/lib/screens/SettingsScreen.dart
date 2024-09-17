import 'dart:convert';
import 'package:flutter_app/AppDrawer.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'FormScreen.dart';
import '../lib/ApiClient.dart';
import '../globals.dart' as globals;

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: Appdrawer(),
      appBar: AppBar(
        title: Text("Settings Page"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Center(
                child: Container(
                    child: TextButton.icon(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.black,
                        backgroundColor: colorScheme.primary,
                      ),
                      onPressed: () async {

                      },
                      icon: const Icon(Icons.exit_to_app),
                      label: const Text('Disconnect'),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
