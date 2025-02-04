import 'package:flutter/material.dart';
import '../models/flight.dart';

class FilteredFlightsScreen extends StatelessWidget {
  final List<Flight> flights;

  const FilteredFlightsScreen({super.key, required this.flights});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Filtered Flights'),
        backgroundColor: Color(0xFF5A7DB8),
      ),
      body: flights.isEmpty
          ? Center(
        child: Text(
          'No flights found.',
          style: TextStyle(
            fontSize: 18,
            color: Colors.grey[800],
          ),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 8),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: _getStatusIcon(flight.status),
              title: Text(
                'Flight ${flight.flightNumber}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Departure: ${flight.origin}'),
                  Text('Arrival: ${flight.destination}'),
                  Text('Departure Time: ${flight.departureTime}'),
                  Text('Arrival Time: ${flight.arrivalTime}'),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
      case 'active':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'delayed':
        return Icon(Icons.warning, color: Colors.orange);
      case 'cancelled':
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.help, color: Colors.grey);
    }
  }
}