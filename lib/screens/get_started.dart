import 'package:flutter/material.dart';
import 'onboarding_screen.dart';

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF5A7DB8),
              Color(0xFF7AA3D8), // Lighter shade at the bottom
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch, // Stretchin children horizontally
            children: [



              // Plane Image with White Circle Background
              Stack(
                alignment: Alignment.center,
                children: [
                  Container(
                    width: 300, // Smaller circle
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.7),
                    ),
                  ),
                  Image.asset(
                    'assets/plane.png',

                    width: 400, // Larger plane image
                    height: 350,
                  ),
                ],
              ),
              SizedBox(height: 30),
              Text(
                'Track',
                textAlign: TextAlign.center, // Center text horizontally
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Komika X',
                ),
              ),
              Text(
                'Your',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 44,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Komika X',
                ),
              ),
              Text(
                'Flight',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 46,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Komika X',
                ),
              ),
              SizedBox(height: 10),
              Text(
                'Stay updated with real-time flight data',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OnboardingScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor:Color(0xFF2B437D),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 95),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Text(
                    'Get Started',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}