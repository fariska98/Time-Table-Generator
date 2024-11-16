
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_table_generation_app/constants/image_class.dart';
import 'package:time_table_generation_app/screens/home/home_screen.dart';
import 'package:time_table_generation_app/utils/app_utils.dart';



class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
   Future.delayed(const Duration(seconds: 2), () {
    AppUtils.navigateTo(context, HomeScreen(),);
    });
  }


   

   
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Mascot character container
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Center(
                  child: Image.asset(
                    ImageClass.timtable,
                    height: MediaQuery.sizeOf(context).height * 0.4,
                  ),
                ),
              ),
              const SizedBox(height: 15),

              // Headline text
              const Text(
                'Welcome to TimeTable\nGenerator',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),

              // Subtitle
              const Text(
                'Helps You to Generate TimeTable Easily',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              const CupertinoActivityIndicator(
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
