import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationManager{
  String _homeScreenText = "Waiting for token...";
  String _messageText = "Waiting for message...";
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  
  Future<void> initState() async{ 
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
        print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch: $message");
      },
      onResume: (Map<String, dynamic> message) async {
        print("onResume: $message");
      },
    );
    _firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
    _firebaseMessaging.getToken().then((String token) async {
      assert(token != null);
      final SharedPreferences prefs = await _prefs;
      prefs.setString("notificationToken", token);
      print("Token is ========== "+token);
    });
  }
}