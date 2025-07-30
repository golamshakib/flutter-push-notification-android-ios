import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotificationService {
  // Private constructor for Singleton pattern
  LocalNotificationService._internal();

  //Singleton instance
  static final LocalNotificationService _instance =
      LocalNotificationService._internal();

  // Factory constructor to return the singleton instance
  factory LocalNotificationService.instance() => _instance;

  // Main Plugin instance for handling notifications
  late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

  // Android-specific initialization settings using app launcher icons
  final _androidInitializationSettings = const AndroidInitializationSettings(
    '@mipmap/ic_launcher',
  );

  //iOS-specific initialization settings with Permission request
  final _iosInitializationSettings = const DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // Android notification channel configuration
  final _androidChannel = const AndroidNotificationChannel(
    'channel_id',
    'Channel name',
    description: 'Android push notification channel',
    importance: Importance.max,
  );
}
