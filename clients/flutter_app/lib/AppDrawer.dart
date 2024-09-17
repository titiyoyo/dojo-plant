import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_app/screens/GPSOffScreen.dart';
import 'package:flutter_app/screens/SettingsScreen.dart';

import 'screens/FormScreen.dart';
import 'globals.dart' as glob;

class DrawerTitle extends Text {
  const DrawerTitle(super.data);

  @override
  TextStyle? get style => const TextStyle(
      fontWeight: FontWeight.w500,
      fontSize: 21
  );
}

class AppdrawerState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              color: Color.fromRGBO(34, 82, 157, 1.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 180,
                  height: 120,
                  child: Image.asset('images/usf-logo-blue.png', fit: BoxFit.scaleDown)
                )
              ],
            ),
          ),
          ListTile(
            title: const DrawerTitle('New Tree'),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => FormScreen(camera: glob.camera))
              );
            },
          ),
          ListTile(
            title: const DrawerTitle('Settings'),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => SettingsScreen())
              );
            },
          ),
          ListTile(
            title: const DrawerTitle('GPS OFF'),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => GPSOffScreen())
              );
            },
          ),
        ],
      ),// Populate the Drawer in the next step.
    );
  }
}

class Appdrawer extends StatefulWidget {
  const Appdrawer({
    super.key,
  });

  @override
  AppdrawerState createState() => AppdrawerState();
}