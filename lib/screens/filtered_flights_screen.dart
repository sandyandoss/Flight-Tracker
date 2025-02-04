import 'package:flutter/material.dart';

class FilteredFlightsScreen extends StatelessWidget {
  final List<dynamic> flights; // List of flights to display

  const FilteredFlightsScreen({Key? key, required this.flights}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Filtered Flights'),
        backgroundColor: Color(0xFF7AA3D8), // Match your app's theme
      ),
      body: Container(
        color: Color(0xFF7AA3D8), // Background color
        child: flights.isEmpty
            ? Center(
          child: Text(
            'No flights found.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          ),
        )
            : ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: flights.length,
          itemBuilder: (context, index) {
            final flight = flights[index];
            return FlightCard(flight: flight);
          },
        ),
      ),
    );
  }
}

class FlightCard extends StatelessWidget {
  final dynamic flight;

  const FlightCard({Key? key, required this.flight}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Flight Number: ${flight['flight']['iata'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Airline: ${flight['airline']['name'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Departure: ${flight['departure']['airport'] ?? 'N/A'} (${flight['departure']['iata'] ?? 'N/A'})',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Arrival: ${flight['arrival']['airport'] ?? 'N/A'} (${flight['arrival']['iata'] ?? 'N/A'})',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Status: ${flight['flight_status'] ?? 'N/A'}',
              style: TextStyle(
                fontSize: 16,
                color: _getStatusColor(flight['flight_status']),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to get status color
  Color _getStatusColor(String? status) {
    switch (status) {
      case 'scheduled':
        return Colors.blue;
      case 'active':
        return Colors.green;
      case 'landed':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}