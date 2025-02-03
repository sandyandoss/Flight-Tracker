import 'package:flutter/material.dart';
import '../models/flight.dart';

class SearchFlightScreen extends StatefulWidget {
  final List<Flight> flights;

  const SearchFlightScreen({Key? key, required this.flights}) : super(key: key);

  @override
  _SearchFlightScreenState createState() => _SearchFlightScreenState();
}

class _SearchFlightScreenState extends State<SearchFlightScreen> {
  final TextEditingController _searchController = TextEditingController();
  Flight? _foundFlight;

  void _searchFlight() {
    final flightNumber = _searchController.text.trim();
    if (flightNumber.isEmpty) {
      setState(() {
        _foundFlight = null;
      });
      return;
    }

    // Find the flight with the matching flight number
    final found = widget.flights.firstWhere(
          (flight) => flight.flightNumber?.toLowerCase() == flightNumber.toLowerCase(),
      orElse: () => Flight(
        flightNumber: null,
        origin: null,
        destination: null,
        departureTime: null,
        arrivalTime: null,
        status: null,
      ), // Default if not found
    );

    setState(() {
      _foundFlight = (found.flightNumber != null) ? found : null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Flight'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Enter Flight Number',
                border: OutlineInputBorder(),
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: _searchFlight,
                ),
              ),
            ),
            SizedBox(height: 20),
            if (_foundFlight != null)
              Card(
                child: ListTile(
                  title: Text('Flight Number: ${_foundFlight!.flightNumber ?? 'Unknown'}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Origin: ${_foundFlight!.origin ?? 'Unknown'}'),
                      Text('Destination: ${_foundFlight!.destination ?? 'Unknown'}'),
                      Text('Departure: ${_foundFlight!.departureTime ?? 'Unknown'}'),
                      Text('Arrival: ${_foundFlight!.arrivalTime ?? 'Unknown'}'),
                      Text('Status: ${_foundFlight!.status ?? 'Unknown'}'),
                    ],
                  ),
                  trailing: _foundFlight!.status?.toLowerCase() == 'landed'
                      ? Text('✈️') // Landed plane emoji
                      : null,
                ),
              )
            else if (_searchController.text.isNotEmpty)
              Text(
                'Flight not found',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}