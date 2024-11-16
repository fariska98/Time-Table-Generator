import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table_generation_app/provider/timetable_provider.dart';
import 'package:time_table_generation_app/screens/course/course_management_screen.dart';
import 'package:time_table_generation_app/screens/home/home_screen.dart';
import 'package:time_table_generation_app/screens/splashscreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();  // Ensures the binding is initialized before Firebase
  await Firebase.initializeApp();  // Initialize Firebase before running the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => TimetableProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Time Table Generator',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}