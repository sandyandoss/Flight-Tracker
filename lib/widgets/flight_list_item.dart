
import 'package:flutter/material.dart';
import '../models/flight.dart';

class FlightListItem extends StatelessWidget {
  final Flight flight;

  FlightListItem({required this.flight});

  // Helper method to get icon and color based on flight status
  Widget _getStatusIcon(String? status) {
    switch (status?.toLowerCase()) {
      case 'on time':
        return Icon(Icons.check_circle, color: Colors.green);
      case 'delayed':
        return Icon(Icons.warning, color: Colors.orange);
      case 'cancelled':
        return Icon(Icons.cancel, color: Colors.red);
      default:
        return Icon(Icons.help, color: Colors.grey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8),
      child: ListTile(
        leading: _getStatusIcon(flight.status), // Status icon
        title: Text('Flight ${flight.flightNumber ?? 'Unknown'}'),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Origin: ${flight.origin ?? 'Unknown'}'),
            Text('Destination: ${flight.destination ?? 'Unknown'}'),
            Text('Departure: ${flight.departureTime ?? 'Unknown'}'),
            Text('Arrival: ${flight.arrivalTime ?? 'Unknown'}'),
          ],
        ),
        trailing: Text(
          flight.status ?? 'Unknown',
          style: TextStyle(
            color: flight.status?.toLowerCase() == 'on time'
                ? Colors.green
                : flight.status?.toLowerCase() == 'delayed'
                ? Colors.orange
                : flight.status?.toLowerCase() == 'cancelled'
                ? Colors.red
                : Colors.grey,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}