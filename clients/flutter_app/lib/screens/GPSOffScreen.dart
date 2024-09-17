import 'package:flutter/material.dart';
import 'package:flutter_app/AppDrawer.dart';
import 'package:geolocator/geolocator.dart';
import '../globals.dart' as globals;

class GPSOffScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GPS Disabled'),
      ),
      drawer: Appdrawer(),
      body: Container(
          child: Padding(
            padding: const EdgeInsets.only(top: 20.0, left: 20),
            child: Column(
              children: [
                Text(
                  'GPS is disabled',
                  style: TextStyle(fontSize: 20),
                ),
                TextButton(
                  onPressed: () async {
                    globals.permission = await Geolocator.requestPermission();
                  },
                  child: Text('Enable GPS')),
                TextButton(
                  onPressed: () async {
                    await Geolocator.openLocationSettings();
                  },
                  child: Text('Open GPS settings'))
              ],
            ),
          )
      ),
    );
  }
}
