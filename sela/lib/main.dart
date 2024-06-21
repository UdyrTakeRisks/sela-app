import 'package:flutter/material.dart';
import 'package:sela/screens/splash/splash_screen.dart';
import 'package:sela/utils/env.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'routes.dart';
import 'theme.dart';

Future<void> main() async {
  await Supabase.initialize(
    url: SUPABASE_URL,
    anonKey: SUPABASE_ANON_KEY,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      // home: const SplashScreen(),
      initialRoute: SplashScreen.routeName,
      // initialRoute: HomeScreen.routeName,
      routes: routes,
    );
  }
}
