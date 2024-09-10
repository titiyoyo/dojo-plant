import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'screens/FormScreen.dart';
import 'globals.dart' as glob;

class AppdrawerState extends State<StatefulWidget> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Text('TreeWallet Menu'),
          ),
          ListTile(
            title: const Text('New Tree'),
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(builder: (context) => FormScreen(camera: glob.camera))
              );
            },
          ),
          ListTile(
            title: const Text('Settings'),
            onTap: () {
              // Update the state of the app.
              // ...
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