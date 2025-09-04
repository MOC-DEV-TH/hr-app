import 'dart:async';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_storage/get_storage.dart';

import '../../main.dart';
import '../utils/secure_storage.dart';
import '../utils/strings.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';

@pragma('vm:entry-point')
void notificationTapBackground(
  NotificationResponse notificationResponse,
) async {
  debugPrint(
    'notification(${notificationResponse.id}) action tapped: '
    '${notificationResponse.actionId} with'
    ' payload: ${notificationResponse.payload}',
  );
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

///local notification
final _localNotifications = FlutterLocalNotificationsPlugin();

///notification channel
const _androidChannel = AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  importance: Importance.high,
);

class FirebaseApi {
  final fCMToken = SecureStorage().getFCMToken();
  final _firebaseMessaging = FirebaseMessaging.instance;

  ///handle message
  void handleMessage(RemoteMessage? message, ProviderContainer ref) async {
    if (message != null) {
      final authStatus = ref.read(getAuthStatusProvider).value;
      if (authStatus == kAuthLoggedIn) {
        await ref.read(secureStorageProvider).saveAuthStatus(kAuthLoggedIn);
        ref.invalidate(secureStorageProvider);
      } else {
        //await ref.read(secureStorageProvider).saveAuthStatus(kAuthNotLoggedIn);
        //ref.invalidate(secureStorageProvider);
      }
    }
  }

  ///init notification
  Future<void> initNotification() async {
    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
    if (Platform.isIOS) {
      String? apnsToken = await _firebaseMessaging.getAPNSToken();
      if (apnsToken != null) {
        await _firebaseMessaging.subscribeToTopic("hr-app");
      } else {
        await Future<void>.delayed(const Duration(seconds: 3));
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          await _firebaseMessaging.subscribeToTopic("hr-app");
        }
      }
    } else {
      await _firebaseMessaging.subscribeToTopic("hr-app");
    }

    ///init timezone handling
    tz.initializeTimeZones();
    final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          MacOSFlutterLocalNotificationsPlugin
        >()
        ?.requestPermissions(alert: true, badge: true, sound: true);

    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('User granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('User granted provisional permission');
    } else {
      print('User declined or has not accepted permission');
    }

    if (fCMToken == null) {
      await Future.delayed(const Duration(seconds: 1));
      final newFCMToken = await _firebaseMessaging.getToken();
      SecureStorage().saveFCMToken(newFCMToken ?? "");
      debugPrint("New FCM Token::$newFCMToken");
    } else {
      debugPrint("Old FCM Token::$fCMToken");
    }

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_androidChannel);

    ///init push notification
    await initPushNotification(container);
  }

  ///init push notification
  Future initPushNotification(ProviderContainer container) async {
    await _firebaseMessaging.subscribeToTopic("hr-app");
    // _firebaseMessaging.getInitialMessage().then((message) async {
    //   final isLoggedIn = GetStorage().read(SecureDataList.isAlreadyLogin.name);
    //   if (isLoggedIn == kAuthLoggedIn) {
    //     await container
    //         .read(secureStorageProvider)
    //         .saveAuthStatus(kAuthLoggedIn);
    //     container.invalidate(secureStorageProvider);
    //   } else {
    //     await container
    //         .read(secureStorageProvider)
    //         .saveAuthStatus(kAuthNotLoggedIn);
    //     container.invalidate(secureStorageProvider);
    //   }
    // });

    FirebaseMessaging.onMessageOpenedApp.listen(
      ((message) => handleMessage(message, container)),
    );

    FirebaseMessaging.onMessage.listen((message) {
      debugPrint("OnMessageReceived:::");

      RemoteNotification? notification = message.notification;
      AndroidNotification? android = message.notification?.android;
      if (notification != null && android != null) {
        _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              _androidChannel.id,
              _androidChannel.name,
              icon: "drawable/app_icon",
            ),
          ),
        );
      }
    });
  }

  ///NOTI DETAILS SETUP
  NotificationDetails notificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'daily_channel_id',
        'Daily Notification',
        channelDescription: 'Daily Notification Channel',
        importance: Importance.max,
        priority: Priority.high,
      ),
      iOS: DarwinNotificationDetails(),
    );
  }

  ///Schedule notification
  Future<void> scheduleNotification({
    int id = 1,
    required String title,
    required String body,
    required int hour,
    required int minute,
  }) async {
    final now = tz.TZDateTime.now(tz.local);

    var scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
      minute,
    );

    ///Schedule the notification
    await _localNotifications.zonedSchedule(
      id,
      title,
      body,
      scheduleDate,
      const NotificationDetails(),
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,

      ///make notification repeat daily at the same time
      matchDateTimeComponents: DateTimeComponents.time,
    );
  }

  ///scheduleDaily9AMCheckInNotification
  static Future<void> scheduleDaily9AMCheckInNotification() async {
    await _localNotifications.zonedSchedule(
      1001,
      'Check In Reminder',
      'Good morning! Don’t forget to check in.',
      _nextInstanceOf9AM(),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'checkin_channel',
          'Check In Notifications',
          channelDescription: 'Daily Check In at 9 AM',
          importance: Importance.max,
          priority: Priority.high,
          icon: "@mipmap/ic_launcher",
        ),

      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  ///checkout reminder
  static Future<void> scheduleCheckoutReminders() async {
    await _localNotifications.zonedSchedule(
      501,
      'Checkout Reminder',
      'It\'s 5 PM! Please don\'t forget to checkout.',
      _nextInstanceOfTime(hour: 17),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'checkout_channel',
          'Checkout Reminders',
          channelDescription: 'Reminders to checkout after work',
          importance: Importance.max,
          priority: Priority.high,
          icon: "@mipmap/ic_launcher",
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    /// 6 PM reminder
    await _localNotifications.zonedSchedule(
      601,
      'Final Checkout Reminder',
      'It\'s 6 PM! Make sure you have checked out.',
      _nextInstanceOfTime(hour: 18),
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'checkout_channel',
          'Checkout Reminders',
          channelDescription: 'Final reminder to checkout',
          importance: Importance.max,
          priority: Priority.high,
          icon: "@mipmap/ic_launcher",
        ),
      ),
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      matchDateTimeComponents: DateTimeComponents.time,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  static tz.TZDateTime _nextInstanceOf9AM() {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      9,
    );

    /// Move to next day if the scheduled time has already passed
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    /// Skip Saturday (6) and Sunday (7)
    while (scheduledDate.weekday == DateTime.saturday || scheduledDate.weekday == DateTime.sunday) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }


  static tz.TZDateTime _nextInstanceOfTime({required int hour}) {
    final now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduled = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      hour,
    );

    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    /// Skip Saturday (6) and Sunday (7)
    while (scheduled.weekday == DateTime.saturday || scheduled.weekday == DateTime.sunday) {
      scheduled = scheduled.add(const Duration(days: 1));
    }

    return scheduled;
  }
}
