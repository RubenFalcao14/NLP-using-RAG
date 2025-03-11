import 'package:flutter/material.dart';
import 'package:nlp/screens/home_screen.dart';
import 'package:nlp/screens/splash_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

void main() async{
  runApp(MyApp());
}
