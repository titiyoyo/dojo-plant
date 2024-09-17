import 'dart:async';
import 'package:geolocator/geolocator.dart';

class LocationService {
  // StreamController pour émettre les positions
  final StreamController<Position> _locationController = StreamController<Position>.broadcast();

  // Getter pour accéder au Stream en dehors de la classe
  Stream<Position> get locationStream => _locationController.stream;

  // Méthode pour démarrer le service de localisation
  void startTracking() {
    Geolocator.getPositionStream(locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10,  // La distance minimale avant d'émettre un nouvel événement
    )).listen((Position position) {
      _locationController.add(position); // Émettre la nouvelle position dans le stream
    });
  }

  // Méthode pour arrêter le tracking
  void stopTracking() {
    _locationController.close();
  }
}