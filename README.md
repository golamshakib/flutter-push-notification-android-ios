
# Flutter Push Notification Android & iOS

## Project Setup

### 1. Add `.env` File
If you haven't already, add the `.env` file to store sensitive information such as API keys to avoid exposing secrets in the git repository.

### 2. Update `.gitignore` File
Ensure the following files are included in your `.gitignore` file to prevent them from being tracked by git:
```plaintext
.env
android/app/google-services.json
ios/Runner/GoogleService-Info.plist
```

### 3. Create Firebase Project
Create a new project on the [Firebase console](https://console.firebase.google.com/).

### 4. Add Dependencies
Add the following dependencies to your `pubspec.yaml` file:
```yaml
firebase_core: ^4.0.0
firebase_messaging: ^16.0.0
flutter_local_notifications: ^19.4.0
```

Alternatively, you can add these dependencies from the command line:
```bash
flutter pub add firebase_core
flutter pub add firebase_messaging
flutter pub add flutter_local_notifications
```

### 5. Log in to Firebase
Check if you're logged in to the Firebase account by running the following command in the terminal:
```bash
firebase login
```

### 6. Activate FlutterFire CLI
If you haven't activated the `flutterfire_cli`, do so by typing the following command:
```bash
dart pub global activate flutterfire_cli
```

### 7. Configure Flutter App with Firebase
Use the `FlutterFire` CLI to configure your app to connect with the Firebase project by running:
```bash
flutterfire configure
```
Select your project in the Firebase console and press ENTER. Ensure both Android and iOS are selected before pressing ENTER.

### 8. Store API Keys in `.env` File
Store the Firebase API keys in your `.env` file:
```env
Firebase_android_api_key = "Your Firebase Android API Key Here"
```

Add these keys to your `firebase_options.dart` file like this:
```dart
apiKey: '${dotenv.env['Firebase_android_api_key']}',
```

### 9. Import Dependencies
If not imported automatically, add the following import to your Dart files:
```dart
import 'package:flutter_dotenv/flutter_dotenv.dart';
```

### 10. Add `.env_example` File
If not added earlier, create a `.env_example` file with the following content to guide other developers:
```env
Firebase_android_api_key = "Your Firebase Android API Key Here"
```

---

## Apple Developer Account Setup for APNs

### 1. Create APNs Key
Go to your Apple Developer Account and navigate to the Keys section.
- Click the `+` icon to add a new key.
- Enable the Apple Push Notifications service (APNs).
- Name your key, click `Configure`, select `Sandbox & Production` for the environment, then click `Save`.
- Download the key and store it for later use.

### 2. Upload APNs Key to Firebase
Go to the Firebase Console, open your Project Settings, and navigate to the `Cloud Messaging` tab.
- Scroll down to the Apple App Messaging Configuration section.
- Upload the APNs Key you downloaded earlier from the Apple Developer account.
- Provide the APNs Key ID and Apple Developer Team ID (both can be found in your Apple Developer account) and click `Upload`.

---

## Configuring iOS Application in Xcode

### 1. Open iOS Module in Xcode
In Android Studio, click on the `ios` folder, then navigate to:
```
Tools > Flutter > Open iOS/macOS module in Xcode
```

### 2. Xcode Configuration
In Xcode, select `Runner > TARGETS > Runner`.
- Go to the `Signing & Capabilities` tab.
- Click the `+ Capability` button.
- Search for `Push Notifications` and add it.
- Also, add the `Background Modes` Capability to handle push notifications when the app is terminated.
- Enable both `Remote Notifications` and `Background Fetch` under `Background Modes`.

### 3. Handle Notifications on App Termination
By default, Firebase will show a notification when the app is terminated. However, if the app is in the foreground, the notifications will not be displayed. To handle this, we use the `flutter_local_notifications` plugin for displaying notifications when the app is in the foreground.

---

## Coding Section

### Local Notification Service

#### 1. Create the Service File (`local_notification_service.dart`)

**Folder Structure:**
Inside the `lib` folder, create a new folder named `services`. Under the `services` folder, create a Dart file called `local_notification_service.dart`.

#### 2. Singleton Pattern Implementation
```dart
class LocalNotificationService {
  // Private constructor for Singleton pattern
  LocalNotificationService._internal();

  // Singleton instance
  static final LocalNotificationService _instance = LocalNotificationService._internal();

  // Factory constructor to return the singleton instance
  factory LocalNotificationService.instance() => _instance;
}
```

#### 3. Notification Plugin Setup
```dart
// Main Plugin instance for handling notifications
late FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin;

// Android-specific initialization settings using app launcher icons
final _androidInitializationSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');

//iOS-specific initialization settings with Permission request
final _iosInitializationSettings = const DarwinInitializationSettings(
  requestAlertPermission: true,
  requestBadgePermission: true,
  requestSoundPermission: true,
);

​​// Android notification channel configuration
final _androidChannel = const AndroidNotificationChannel(
  'channel_id',
  'Channel name',
  description: 'Android push notification channel',
  importance: Importance.max,
);
```

#### 4. Plugin Initialization Check
```dart
// Flag to track initialization status
bool _isFlutterLocalNotificationInitialized = false;

// Counter for generating unique notification IDs
int _notificationIdCounter = 0;

/// Initializes the local notifications plugin for Android and iOS.
Future<void> init() async {
  if (_isFlutterLocalNotificationInitialized) {
    return;
  }

  // Create plugin instance
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Combine platform-specific settings
  final initializationSettings = InitializationSettings(
    android: _androidInitializationSettings,
    iOS: _iosInitializationSettings,
  );

  // Initialize plugin with settings and callback for notification taps
  await _flutterLocalNotificationsPlugin.initialize(
    initializationSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      log('Foreground notification has been tapped: ${response.payload}');
    },
  );

  // Create Android notification channel
  await _flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(_androidChannel);

  // Mark initialization as complete
  _isFlutterLocalNotificationInitialized = true;
}
```

#### 5. Show Notification
```dart
/// Show a local notification with the given title, body, and payload
Future<void> showNotification(
  String? title,
  String? body,
  String? payload,
) async {
  // Android-specific notification details
  AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    _androidChannel.id,
    _androidChannel.name,
    channelDescription: _androidChannel.description,
    priority: Priority.high,
  );

// iOS-specific notification details
DarwinNotificationDetails iosDetails = const DarwinNotificationDetails();

// Combine platform-specific details
final notificationDetails = NotificationDetails(
  android: androidDetails,
  iOS: iosDetails,
);

// Display the notification
await _flutterLocalNotificationsPlugin.show(
  _notificationIdCounter++,
  title,
  body,
  notificationDetails,
  payload: payload,
);

```
---

### Firebase Messaging Service

#### 1. Create the Service File (`firebase_messaging_service.dart`)

**Folder Structure:**
Inside the `lib` folder, create a new folder named `services`. Under the `services` folder, create a Dart file called `firebase_messaging_service.dart`.

#### 2. Singleton Pattern Implementation
```dart
class FirebaseMessagingService {
  FirebaseMessagingService._internal();
  static final FirebaseMessagingService _instance = FirebaseMessagingService._internal();
  factory FirebaseMessagingService.instance() => _instance;
}
```

#### 3. Local Notification Service Integration
```dart
LocalNotificationService? _localNotificationService;

Future<void> init({required LocalNotificationService localNotificationService}) async {
  _localNotificationService = localNotificationService;
  _handlePushNotificationsToken();
  _requestPermission();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen(_onForegroundMessage);
  FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
  final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    _onMessageOpenedApp(initialMessage);
  }
}
```

---

### Main Dart File Configuration

In your `main.dart` file, initialize both services:

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final localNotificationService = LocalNotificationService.instance();
  await localNotificationService.init();

  final firebaseMessagingService = FirebaseMessagingService.instance();
  await firebaseMessagingService.init(localNotificationService: localNotificationService);

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (value) {
      Logger.init(kReleaseMode ? LogMode.live : LogMode.debug);
      runApp(const MyApp());
    },
  );
}
```

---

## Conclusion

Now you can run the app and test notifications on both Android and iOS. 

1. Run the app to get the FCM token.
2. Go to Firebase Console's Cloud Messaging section to send and test notifications for foreground, background, or app-termination states.
