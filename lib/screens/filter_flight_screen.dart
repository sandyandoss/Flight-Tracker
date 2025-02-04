import 'dart:convert';
import 'package:flutter/material.dart';
import 'filtered_flights_screen.dart';
import 'flights_screen.dart';
import 'package:http/http.dart' as http;

class FilterFlightScreen extends StatefulWidget {
  const FilterFlightScreen({super.key});

  @override
  State<FilterFlightScreen> createState() => _FilterFlightScreenState();
}

class _FilterFlightScreenState extends State<FilterFlightScreen> {
  final TextEditingController _departureController = TextEditingController();
  final TextEditingController _arrivalController = TextEditingController();

  final List<String> predefinedAirports = ['LAX', 'JFK', 'CDG', 'DXB', 'LHR'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: const Color(0xFF7AA3D8),
        child: Column(
          children: [
            Container(
              height: 200,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(300),
                  bottomRight: Radius.circular(300),
                ),
              ),
              child: Center(child: Image.asset('assets/plane.png')),
            ),
            const SizedBox(height: 20),
            const Text(
              'Find your flight',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 40,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(64, 147, 206, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      // Handle Departures button press
                    },
                    child: const Text(
                      'Departures',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  height: 40,
                  width: 140,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromRGBO(215, 234, 248, 100),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                    ),
                    onPressed: () {
                      // Handle Arrivals button press
                    },
                    child: const Text(
                      'Arrivals',
                      style: TextStyle(fontSize: 14, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              width: 308,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('From'),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _departureController.text.isEmpty
                        ? null
                        : _departureController.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromRGBO(224, 237, 246, 100),
                    ),
                    items: predefinedAirports.map((airport) {
                      return DropdownMenuItem(
                        value: airport,
                        child: Text(airport),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _departureController.text = value!;
                      });
                    },
                    hint: const Text('Select departure airport'),
                  ),
                  const SizedBox(height: 10),
                  const Text('To'),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: _arrivalController.text.isEmpty
                        ? null
                        : _arrivalController.text,
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Color.fromRGBO(224, 237, 246, 100),
                    ),
                    items: predefinedAirports.map((airport) {
                      return DropdownMenuItem(
                        value: airport,
                        child: Text(airport),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _arrivalController.text = value!;
                      });
                    },
                    hint: const Text('Select arrival airport'),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    height: 50,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color.fromRGBO(64, 147, 206, 100),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        final departure = _departureController.text;
                        final arrival = _arrivalController.text;
                        if (departure.isNotEmpty && arrival.isNotEmpty) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FilteredFlightsScreen(
                                  flights: []), // Mock flights for now
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please select both departure and arrival airports.'),
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Filter Flights',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              height: 50,
              width: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromRGBO(64, 147, 206, 100),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FlightsScreen()),
                  );
                },
                child: const Text(
                  'View All Flights',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
