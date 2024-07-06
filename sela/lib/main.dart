import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:sela/firebase/PushNotificationService.dart';
import 'package:sela/screens/splash/splash_screen.dart';
import 'package:sela/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'components/new_custom_bottom_navbar.dart';
import 'firebase_options.dart';
import 'routes.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  await Firebase.initializeApp(options: DefaultFirebaseOptions.android);
  await PushNotificationService().initNotificatons();
  bool isValid = await isCookieValid();
  FlutterNativeSplash.remove();
  runApp(MyApp(
      initialRoute: isValid ? MainScreen.routeName : SplashScreen.routeName));
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      navigatorKey: navigatorKey,
      initialRoute: MainScreen.routeName,
      routes: routes,
    );
  }
}


Future<bool> isCookieValid() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? expirationTimestamp = prefs.getString('cookieExpirationTimestamp');
  if (expirationTimestamp == null) {
    return false; // No timestamp means the cookie is not valid
  }
  DateTime expirationDate = DateTime.parse(expirationTimestamp);
  return DateTime.now().isBefore(expirationDate);
}
