import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  debugPrint("----------------------------");
  debugPrint("background message Title: ${message.notification!.title}");
  debugPrint("background message Body: ${message.notification!.body}");
  debugPrint("----------------------------");
}

class NotiMain extends StatefulWidget {
  const NotiMain({super.key});

  @override
  State<NotiMain> createState() => _NotiMain();
}

class _NotiMain extends State<NotiMain> {
  @override
  void initState() {
    super.initState();

    // Background/Terminated message handler 등록
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // 메시지 리스너 등록
    _initFirebaseMessaging();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Firebase Cloud Messaging'),
        backgroundColor: Colors.orange,
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Icon(Icons.notification_add),
      ),
    );
  }

  Future<void> _initFirebaseMessaging() async {
    FirebaseMessaging fcm = FirebaseMessaging.instance;

    // 알림 권한이 승인된 후에만 성공적으로 토큰을 발급받을 수 있다.
    NotificationSettings settings = await fcm.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permissions: ${settings.authorizationStatus}');

    String? token = await fcm.getToken();
    debugPrint('----------------------------------------------');
    debugPrint('FCM Token: $token');
    debugPrint('----------------------------------------------');

    // 토큰 갱신 모니터링
    fcm.onTokenRefresh.listen((newToken) {
      token = newToken;
      debugPrint('FCM new Token: $token');
    });

    // Foreground 메시지 수신 처리 (앱이 열려있는 상태)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('----------------------------------------------');
      debugPrint('Foreground Message');
      debugPrint('----------------------------------------------');
      
      if (message.notification != null) {
        _showMessage('Foreground', message.notification!);
      }
    });

    // Background 메시지 수신처리 (앱이 백그라운드 상태)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('----------------------------------------------');
      debugPrint('Background Message');
      debugPrint('----------------------------------------------');

      if (message.notification != null) {
        _showMessage('Background', message.notification!);
      }
    });

    // 앱이 완전히 종료된 상태에서 사용자 알림을 클릭하여 앱이 실행될 때 수신된 FCM 메시지 데이터를 가저온다.
    RemoteMessage? message = await fcm.getInitialMessage();

    if (message != null) {
      debugPrint('----------------------------------------------');
      debugPrint('Terminated Message');
      debugPrint('----------------------------------------------');

      if (message.notification != null) {
        _showMessage('Terminated', message.notification!);
      }
    }
  }

  void _showMessage(String type, RemoteNotification notification) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$type 알림: ${notification.title}'),
          content: Text('${notification.body}'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('확인'),
            ),
          ],
        );
      },
    );
  }
}
