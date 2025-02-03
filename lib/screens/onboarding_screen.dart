import 'package:flutter/material.dart';
import 'flights_screen.dart'; // Import your Flights Screen

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0; // Tracks the current step in the onboarding flow

  // Steps for the onboarding process
  final List<Map<String, String>> _steps = [
    {
      'title': 'Welcome to Flight Tracker!',
      'description': 'Track real-time flights, departures, arrivals, and delays.',
    },
    {
      'title': 'Flight Status Updates',
      'description': 'Stay updated on the status of flights, whether on time or delayed.',
    },
    {
      'title': 'Auto-Refresh Flight Data',
      'description': 'Auto-refresh every 10 seconds to stay current with flight information.',
    },
  ];

  // Navigates to the Flights Screen
  void _navigateToFlightsScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FlightsScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: _navigateToFlightsScreen, // Skip onboarding
            child: Text(
              'Skip',
              style: TextStyle(color: Colors.blue, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Step Indicator
            Row(
              children: List.generate(
                _steps.length,
                    (index) => Expanded(
                  child: Container(
                    height: 4,
                    margin: EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      color: _currentStep == index ? Colors.blue : Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 40),

            // Title and Description
            Text(
              _steps[_currentStep]['title']!,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
            SizedBox(height: 16),
            Text(
              _steps[_currentStep]['description']!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            SizedBox(height: 40),

            // Flight Tracker Setup Flow (Example for Step 1)
            if (_currentStep == 1)
              Column(
                children: [
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Flight Number',
                      labelStyle: TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    decoration: InputDecoration(
                      labelText: 'Airport (Optional)',
                      labelStyle: TextStyle(color: Colors.blue),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.orange),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                      ),
                    ),
                  ),
                ],
              ),

            // Auto-Refresh Flow (Example for Step 2)
            if (_currentStep == 2)
              Column(
                children: [
                  SwitchListTile(
                    title: Text('Enable Auto-Refresh'),
                    value: true, // Example value
                    onChanged: (value) {
                      // Handle auto-refresh toggle
                    },
                    activeColor: Colors.blue,
                  ),
                  SizedBox(height: 20),
                  ListTile(
                    leading: Icon(Icons.refresh, color: Colors.blue),
                    title: Text('Refresh Interval'),
                    subtitle: Text('Every 10 seconds'), // Example interval
                    onTap: () {
                      // Handle interval change
                    },
                  ),
                ],
              ),

            Spacer(),

            // Next
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_currentStep < _steps.length - 1) {
                    setState(() {
                      _currentStep++; // Move to the next step
                    });
                  } else {
                    _navigateToFlightsScreen(); // Finish onboarding
                  }
                },
                style: ElevatedButton.styleFrom(

                  backgroundColor: Color(0xFF7AA3D8),
                  foregroundColor: Color(0xFF7AA3D8),
    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 95), // Button padding
    shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(17), // Rounded corners
    ),
    ), child: Text(
                  _currentStep == _steps.length - 1 ? 'Get Started' : 'Next',

                  style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
