// ignore_for_file: avoid_print

import 'package:recipe/utils/export.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await setupFirebaseMessaging();
  runApp(const MyApp());
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("📩 Background message: ${message.notification?.title}");
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Request permission
  await messaging.requestPermission();

  // Foreground messages
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    print("📨 Foreground: ${message.notification?.title}");
  });

  // App opened from background via notification tap
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    print("🚀 Background tapped: ${message.notification?.title}");
  });

  String? token = await FirebaseMessaging.instance.getToken();
  print("📲 FCM Token: $token");
  // App launched from terminated state via notification
  RemoteMessage? initialMessage = await messaging.getInitialMessage();
  if (initialMessage != null) {
    print(
      "🔥 App launched from notification: ${initialMessage.notification?.title}",
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: routes(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
