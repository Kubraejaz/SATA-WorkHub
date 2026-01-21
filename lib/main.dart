import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'splash/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://cnevsmmlogfsohhswazy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImNuZXZzbW1sb2dmc29oaHN3YXp5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjgzOTQxNzAsImV4cCI6MjA4Mzk3MDE3MH0.w6vcyaYjx-H7fskA6z12OQm72h2NMozvPyzq2GcEzIo',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
