import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension SnackBarExtensions on BuildContext {
  void showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green[700],
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void showErrorSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

extension DialogExtensions on BuildContext {
  void showErrorDialog(String message, String title) {
    showDialog(
      context: this,
      builder: (ctx) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

extension GreetingExtension on DateTime {
  String get greeting {
    final hour = this.hour;

    if (hour >= 5 && hour < 12) {
      return 'Good Morning';
    } else if (hour >= 12 && hour < 17) {
      return 'Good Afternoon';
    } else if (hour >= 17 && hour < 21) {
      return 'Good Evening';
    } else {
      return 'Good Night';
    }
  }
}

extension FormattedDateExtension on DateTime {
  /// Example: "Tuesday, Nov 17, 2025"
  String get formattedFullDate {
    final formatter = DateFormat('EEEE, MMM d, y');
    return formatter.format(this);
  }
}


extension FormattedTimeExtension on DateTime {
  /// Returns time in 12-hour format with AM/PM, e.g. "09:00 AM"
  String get time12h {
    return DateFormat('hh:mm a').format(this);
  }
}

extension StringCasingExtension on String {
  /// Capitalizes the first letter of the string
  String capitalizeFirstLetter() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }
}

extension DioExceptionX on DioException {
  String get errorMessage {
    final data = response?.data;

    if (data is Map && data['message'] is String && (data['message'] as String).trim().isNotEmpty) {
      return data['message'] as String;
    }

    switch (type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return 'Network timeout. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection.';

      case DioExceptionType.badResponse:
        return 'Request failed (${response?.statusCode ?? 'unknown'}).';

      default:
        return 'Unexpected error occurred.';
    }
  }
}


/// Flexible parser for DateTime | ISO string | "hh:mm a" | "HH:mm"
extension AnyToDateTimeX on Object? {
  /// Returns a DateTime when possible, or null.
  DateTime? asDateTimeFlex() {
    final v = this;
    if (v == null) return null;
    if (v is DateTime) return v;

    if (v is String) {
      final iso = DateTime.tryParse(v);
      if (iso != null) return iso;

      final now = DateTime.now();
      try {
        final t12 = DateFormat('hh:mm a').parse(v);
        return DateTime(now.year, now.month, now.day, t12.hour, t12.minute);
      } catch (_) {}
      try {
        final t24 = DateFormat('HH:mm').parse(v);
        return DateTime(now.year, now.month, now.day, t24.hour, t24.minute);
      } catch (_) {}
    }
    return null;
  }
}

/// Duration → "HH:MM Hrs" (clamped at 00:00)
extension DurationHrsLabelX on Duration {
  String toHrsLabel({bool withSuffix = true}) {
    var d = this;
    if (d.isNegative) d = Duration.zero;
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final hhmm = '${h.toString().padLeft(2, '0')}:${m.toString().padLeft(2, '0')}';
    return withSuffix ? '$hhmm Hrs' : hhmm;
  }
}



