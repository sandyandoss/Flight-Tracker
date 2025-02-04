import 'package:flutter/material.dart';
import 'filter_flight_screen.dart';
import 'get_started.dart'; // Import the get started screen

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentStep = 0;

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

  void _navigateToFilterFlightScreen() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FilterFlightScreen()),
    );
  }

  // Handle back button press
  Future<bool> _onWillPop() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GetStarted()),
    );
    return Future.value(false); // Prevent default back action
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop, // Handle back button press
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          actions: [
            TextButton(
              onPressed: _navigateToFilterFlightScreen,
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
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
              Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_currentStep < _steps.length - 1) {
                      setState(() {
                        _currentStep++;
                      });
                    } else {
                      _navigateToFilterFlightScreen();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF7AA3D8),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                  ),
                  child: Text(
                    _currentStep == _steps.length - 1 ? 'Get Started' : 'Next',
                    style: TextStyle(fontSize: 21, color: Colors.white, fontWeight: FontWeight.bold),
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
