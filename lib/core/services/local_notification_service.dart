class LocalNotificationService {
  // Private constructor for Singleton pattern
  LocalNotificationService._internal();

  //Singleton instance
  static final LocalNotificationService _instance = LocalNotificationService._internal();

  // Factory constructor to return the singleton instance
  factory LocalNotificationService.instance() => _instance;

}