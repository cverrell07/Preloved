import 'package:flutter/material.dart';
import 'package:preloved/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:preloved/pages/splash_screen.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform,);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Preloved',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xffFF9F2D)),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}