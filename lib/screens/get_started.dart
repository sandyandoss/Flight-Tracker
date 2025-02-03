import 'package:flutter/material.dart';
import 'onboarding_screen.dart'; //  this is your next screen

class GetStarted extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Set the background color to #C8E0F4
      backgroundColor: Color(0xFF7AA3D8), // Hex color for #C8E0F4
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Plane Image
            Image.asset(
              'assets/plane.png',
              width: 500,
              height: 400,
            ),


            // "Track Your Flight" Title
            Text(
              'Track',
              style: TextStyle(
                color: Colors.white, // Blue accent text color
                fontSize: 44, // Big font size
                fontWeight: FontWeight.bold, // Bold style
                fontFamily: 'Komika X',
              ),
            ),
            Text(
              'Your',
              style: TextStyle(
                color: Colors.white, // Blue accent text color
                fontSize: 44, // Big font size
                fontWeight: FontWeight.bold, // Bold style
                fontFamily: 'Komika X',
              ),
            ),
            Text(
              'Flight',
              style: TextStyle(
                color: Colors.white, // Blue accent text color
                fontSize: 46, // Big font size
                fontWeight: FontWeight.bold, // Bold style
                fontFamily: 'Komika X',
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Stay updated with real-time flight data',
              style: TextStyle(
                color: Colors.white, // Blue accent text color
                fontSize: 17,
              ),
            ),
            SizedBox(height: 50), // Spacing between title and button

            // "Get Started" Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40), // Add horizontal padding
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the next screen
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => OnboardingScreen()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.white, // White text color
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 95), // Button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(17), // Rounded corners
                  ),
                ),
                child: Text(
                  'Get Started',
                  style: TextStyle(
                    color: Color(0xFF435EAF),
                    fontSize: 21, // Big font size
                    fontWeight: FontWeight.bold, // Bold text
                  ),
                ),
              ),
            ),
            SizedBox(height: 10), // Spacing at the bottom
          ],
        ),
      ),
    );
  }
}