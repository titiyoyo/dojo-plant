import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_app/lib/LocationService.dart';

class GPSWidgetRow extends StatelessWidget {
  final String label;
  final String value;
  final TextStyle? style;

  const GPSWidgetRow({
    super.key,
    required this.label,
    required this.value,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Text(
            label,
            style: style,
          )
        ),
        SizedBox(
          width: 150,
          child: Text(
            value,
            style: style,
          )
        ),
      ],
    );
  }
}

class GpsWidget extends StatefulWidget {
  @override
  _GpsWidgetState createState() => _GpsWidgetState();
}

class _GpsWidgetState extends State<GpsWidget> {
  final LocationService _locationService = LocationService();
  Position? _currentPosition;

  @override
  void initState() {
    super.initState();

    // Démarrer le service de localisation et écouter les événements de position
    _locationService.startTracking();

    _locationService.locationStream.listen((Position position) {
      setState(() {
        _currentPosition = position;
      });
    });
  }

  @override
  void dispose() {
    // Arrêter le tracking lorsque le widget est détruit
    _locationService.stopTracking();
    super.dispose();
  }

  TextStyle accuracyStyle (double? accuracy) {
    if (accuracy == null || accuracy > 10) {
      return const TextStyle(
          color: Colors.red
      );
    }

    return const TextStyle(
      color: Colors.green
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: _currentPosition == null
          ? Row(
            children: [
              SizedBox(
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                ),
                height: 15,
                width: 15,
              ),
              Padding(
                  padding: EdgeInsets.all(10),
                  child: Text('Getting GPS')
              ),
            ],
          )
          : Container(
              child: Column(
              children: [
                GPSWidgetRow(
                  label: 'Accuracy',
                  value: _currentPosition!.accuracy.truncate().toString(),
                  style: accuracyStyle(_currentPosition!.accuracy),
                ),
                GPSWidgetRow(
                  label: 'Latitude',
                  value: _currentPosition!.latitude.toString()
                ),
                GPSWidgetRow(
                  label: 'Longitude',
                  value: _currentPosition!.longitude.toString()
                ),
              ],
            )),
      ),
    );
  }
}
