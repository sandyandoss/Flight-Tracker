import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/flight.dart';
import '../utils/constants.dart';

class ApiService {
  Future<List<Flight>> fetchFlights() async {
    // Make an API request to fetch flight data
    final response = await http.get(Uri.parse('$baseUrl/flights?access_key=$apiKey'));

    // Check if the request was successful
    if (response.statusCode == 200) {
      // Parse the JSON response
      final data = json.decode(response.body);
      // Extract the list of flights from the "data" field
      final List<dynamic> flightsJson = data['data'];
      // Convert each JSON object into a Flight object
      return flightsJson.map((json) => Flight.fromJson(json)).toList();
    } else {
      // Handle API errors
      throw Exception('Failed to load flights');
    }
  }
}
