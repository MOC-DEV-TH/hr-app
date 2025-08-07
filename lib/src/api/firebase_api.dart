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

@pragma('vm:entry-point')
void notificationTapBackground(
    NotificationResponse notificationResponse) async {
  debugPrint('notification(${notificationResponse.id}) action tapped: '
      '${notificationResponse.actionId} with'
      ' payload: ${notificationResponse.payload}');
  if (notificationResponse.input?.isNotEmpty ?? false) {
    debugPrint(
        'notification action tapped with input: ${notificationResponse.input}');
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
        await ref.read(secureStorageProvider).saveAuthStatus(kAuthNotLoggedIn);
        ref.invalidate(secureStorageProvider);
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
        await Future<void>.delayed(
          const Duration(
            seconds: 3,
          ),
        );
        apnsToken = await _firebaseMessaging.getAPNSToken();
        if (apnsToken != null) {
          await _firebaseMessaging.subscribeToTopic("hr-app");
        }
      }
    } else {
      await _firebaseMessaging.subscribeToTopic("hr-app");
    }

    await _localNotifications
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
    await _localNotifications
        .resolvePlatformSpecificImplementation<
        MacOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

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
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidChannel);

    ///init push notification
    await initPushNotification(container);
  }

  ///init push notification
  Future initPushNotification(ProviderContainer container) async {
    await _firebaseMessaging.subscribeToTopic("hr-app");
    _firebaseMessaging.getInitialMessage().then((message) async {
      final isLoggedIn = GetStorage().read(SecureDataList.isAlreadyLogin.name);
      if (isLoggedIn == kAuthLoggedIn) {
        await container
            .read(secureStorageProvider)
            .saveAuthStatus(kAuthLoggedIn);
        container.invalidate(secureStorageProvider);
      } else {
        await container
            .read(secureStorageProvider)
            .saveAuthStatus(kAuthNotLoggedIn);
        container.invalidate(secureStorageProvider);
      }
    });

    FirebaseMessaging.onMessageOpenedApp
        .listen(((message) => handleMessage(message, container)));

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
            ));
      }
    });
  }
}