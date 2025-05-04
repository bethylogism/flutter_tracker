import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DrinkTrackerModel extends ChangeNotifier {
  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  int _drinkCount = 0;

  int get drinkCount => _drinkCount;

  DrinkTrackerModel() {
    _initializeNotifications();
    _loadCount();
  }

  Future<void> _initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
          android: initializationSettingsAndroid,
          iOS: initializationSettingsIOS,
        );

    await _notificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (response.actionId == 'add_drink') {
          addDrink();
        } else if (response.actionId == 'subtract_drink') {
          subtractDrink();
        }
      },
    );

    // Define notification actions
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'drink_tracker_channel',
      'Drink Tracker',
      description: 'Track your drink count',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  Future<void> _loadCount() async {
    final prefs = await SharedPreferences.getInstance();
    _drinkCount = prefs.getInt('drink_count') ?? 0;
    notifyListeners();
  }

  Future<void> addDrink() async {
    _drinkCount++;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('drink_count', _drinkCount);
    await _sendPersistentNotification();
  }

  Future<void> subtractDrink() async {
    if (_drinkCount > 0) {
      _drinkCount--;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      prefs.setInt('drink_count', _drinkCount);
      await _sendPersistentNotification();
    }
  }

  Future<void> resetCount() async {
    _drinkCount = 0;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt('drink_count', _drinkCount);
  }

  Future<void> _sendPersistentNotification() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
          'drink_tracker_channel',
          'Drink Tracker',
          channelDescription: 'Track your drink count',
          importance: Importance.high,
          priority: Priority.high,
          ongoing: true,
          actions: <AndroidNotificationAction>[
            AndroidNotificationAction('add_drink', 'Add Drink'),
            AndroidNotificationAction('subtract_drink', 'Subtract Drink'),
          ],
        );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      categoryIdentifier: 'drink_tracker_category',
    );

    const NotificationDetails platformDetails = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    await _notificationsPlugin.show(
      0,
      'Drink Tracker',
      'Current drink count: $_drinkCount',
      platformDetails,
    );
  }
}
