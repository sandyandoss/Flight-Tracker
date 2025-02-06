import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/flight.dart';


class FilteredFlightsScreen extends StatefulWidget {
  final String departure;
  final String arrival;

  const FilteredFlightsScreen({
    required this.departure,
    required this.arrival,
    Key? key,
  }) : super(key: key);

  @override
  State<FilteredFlightsScreen> createState() => _FilteredFlightsScreenState();
}

class _FilteredFlightsScreenState extends State<FilteredFlightsScreen> {
  List<Flight> flights = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchFlights();
  }

  Future<void> fetchFlights() async {
    const String apiKey = '03173056700d76e1d58557d2ced95e19';
    final String url =
        'http://api.aviationstack.com/v1/flights?access_key=$apiKey&dep_iata=${widget.departure}&arr_iata=${widget.arrival}&limit=10';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        final List<dynamic> flightData = data['data'] ?? [];

        setState(() {
          flights = flightData.map((json) => Flight.fromJson(json)).toList();
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load flights');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching flights: $e')),
      );
    }
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
      case 'scheduled':
        return Colors.green;
      case 'cancelled':
      case 'diverted':
        return Colors.red;
      case 'landed':
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Filtered Flights",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF5A7DB8)),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : flights.isEmpty
          ? const Center(child: Text('No flights found.'))
          : ListView.builder(
        itemCount: flights.length,
        itemBuilder: (context, index) {
          final flight = flights[index];
          return Card(
            margin: const EdgeInsets.all(10),
            elevation: 5,
            child: ListTile(
              title: Text(
                '${flight.airline} - ${flight.flightNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('From: ${flight.origin}'),
                  Text('To: ${flight.destination}'),
                  Text('Departure: ${flight.departureTime}'),
                  Text('Arrival: ${flight.arrivalTime}'),
                  Text(
                    'Status: ${flight.status}',
                    style: TextStyle(
                      color: getStatusColor(flight.status),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}