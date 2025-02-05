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
  bool _isDeparture = true;
  final List<String> predefinedAirports = ['LAX', 'JFK', 'CDG', 'DXB', 'LHR'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF5A7DB8), Color(0xFF7AA3D8)],
          ),
        ),
        child: Column(
          children: [
            Container(
              height: 250,

              child: Stack(
                alignment: Alignment.center,
                children: [
                  Positioned(
                    top: -50,
                    child: Container(
                      width: MediaQuery.of(context).size.width * 1.5,
                      height: 300,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),

                      ),
                    ),
                  ),
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 600),
                    top: _isDeparture ? 50 : 95,
                    child: Image.asset(
                      'assets/R.png',
                      width: 255,
                      color: Colors.black.withOpacity(1),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Column(
                children: [
                  const Text(
                    'Find Your Flight',
                    style: TextStyle(
                      fontFamily: 'Komika X',
                      fontSize: 32,

                      color: Colors.white,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Departures'),
                            selected: _isDeparture,
                            onSelected: (bool selected) {
                              setState(() {
                                _isDeparture = selected;
                              });
                            },
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.white,
                            labelStyle: TextStyle(
                              color: _isDeparture
                                  ? const Color(0xFF2B437D)
                                  : const Color(0xFF7AA3D8),
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                        Expanded(
                          child: ChoiceChip(
                            label: const Text('Arrivals'),
                            selected: !_isDeparture,
                            onSelected: (bool selected) {
                              setState(() {
                                _isDeparture = !selected;
                              });
                            },
                            backgroundColor: Colors.transparent,
                            selectedColor: Colors.white,
                            labelStyle: TextStyle(
                              color: !_isDeparture
                                  ? const Color(0xFF2B437D)
                                  : const Color(0xFF7AA3D8),
                              fontWeight: FontWeight.bold,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        _buildModernDropdown(
                          controller: _departureController,
                          label: 'From',
                          icon: Icons.flight_takeoff_rounded,
                        ),
                        const SizedBox(height: 20),
                        _buildModernDropdown(
                          controller: _arrivalController,
                          label: 'To',
                          icon: Icons.flight_land_rounded,
                        ),
                        const SizedBox(height: 30),
                        Container(
                          height: 55,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF5A7DB8), Color(0xFF7AA3D8)],
                            ),
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            onPressed: () {
                              final departure = _departureController.text;
                              final arrival = _arrivalController.text;
                              if (departure.isNotEmpty && arrival.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                    const FilteredFlightsScreen(flights: []),
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
                              'Search Flights',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FlightsScreen()),
                      );
                    },
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                    child: const Text('View All Flights'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernDropdown({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              backgroundColor: Colors.transparent,
              builder: (context) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.vertical(
                      top: Radius.circular(25),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Select $label Airport',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2B437D),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ...predefinedAirports.map((airport) {
                        return ListTile(
                          leading: Icon(
                            Icons.airplanemode_active_rounded,
                            color: Colors.grey.shade600,
                          ),
                          title: Text(
                            airport,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade800,
                            ),
                          ),
                          onTap: () {
                            setState(() {
                              controller.text = airport;
                            });
                            Navigator.pop(context);
                          },
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.grey.shade300,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.text.isEmpty ? 'Select airport' : controller.text,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: controller.text.isEmpty
                        ? Colors.grey.shade600
                        : Colors.grey.shade800,
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down_rounded,
                  color: Colors.grey.shade600,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}