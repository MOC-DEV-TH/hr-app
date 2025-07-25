import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class LocationService {
  static const double officeLatitude = 13.755204682621741;
  static const double officeLongitude = 100.5332719248907;
  static const double allowedRadius = 10.0;


  /// Check if location services are enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  /// Check location permissions
  static Future<LocationPermission> checkPermission() async {
    return await Geolocator.checkPermission();
  }

  /// Request location permissions
  static Future<LocationPermission> requestPermission() async {
    return await Geolocator.requestPermission();
  }

  /// Get current position
  static Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  /// Calculate distance between two points in km
  static double calculateDistance(
      double startLatitude,
      double startLongitude,
      double endLatitude,
      double endLongitude,
      ) {
    return Geolocator.distanceBetween(
      startLatitude,
      startLongitude,
      endLatitude,
      endLongitude,
    ) /
        1000; /// Convert meters to km
  }

  /// Check if user is within allowed radius
  static Future<bool> isWithinOfficeRadius() async {
    try {
      final position = await getCurrentPosition();
      debugPrint("CurrentLat>>>>>>${position.latitude}");
      debugPrint("CurrentLong>>>>>>>>${position.longitude}");
      final distance = calculateDistance(
        position.latitude,
        position.longitude,
        officeLatitude,
        officeLongitude,
      );
      return distance <= allowedRadius;
    } catch (e) {
      return false;
    }
  }
}