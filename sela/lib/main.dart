import 'package:flutter/material.dart';
import 'package:sela/screens/home/home_screen.dart'; // Import your home screen
import 'package:sela/screens/splash/splash_screen.dart';
import 'package:sela/utils/env.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'routes.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );

  bool isValid = await isCookieValid();
  runApp(MyApp(
      initialRoute: isValid ? HomeScreen.routeName : SplashScreen.routeName));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      initialRoute: initialRoute,
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
