import 'dart:async';
import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../services/api_service.dart';
import '../widgets/flight_list_item.dart';
import '../widgets/refresh_control.dart';
import 'search_flight_screen.dart'; // Import the new search page

class FlightsScreen extends StatefulWidget {
  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  late Future<List<Flight>> futureFlights;
  Timer? _timer;
  bool _autoRefreshEnabled = true;
  DateTime? _lastUpdated;

  // Predefined airports for filtering
  final List<String> predefinedAirports = ['LAX', 'DBX', 'CDG', 'JFK', 'LHR'];
  String? _selectedDeparture;
  String? _selectedArrival;

  @override
  void initState() {
    super.initState();
    _fetchFlights();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _fetchFlights({String? departure, String? arrival}) {
    setState(() {
      futureFlights = ApiService().fetchFlights().then((flights) {
        // Apply filters if provided
        if (departure != null) {
          flights = flights.where((flight) => flight.origin == departure).toList();
        }
        if (arrival != null) {
          flights = flights.where((flight) => flight.destination == arrival).toList();
        }

        setState(() {
          _lastUpdated = DateTime.now();
        });
        return flights;
      });
    });
  }

  void _startTimer() {
    if (_autoRefreshEnabled) {
      _timer = Timer.periodic(Duration(seconds: 10), (timer) {
        _fetchFlights();
      });
    }
  }

  void _toggleAutoRefresh() {
    setState(() {
      _autoRefreshEnabled = !_autoRefreshEnabled;
      if (_autoRefreshEnabled) {
        _startTimer();
      } else {
        _timer?.cancel();
      }
    });
  }

  void _openSearch() async {
    // Fetch flights and navigate to the search page
    final flights = await futureFlights;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFlightScreen(flights: flights),
      ),
    );
  }

  void _openFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Filter Flights'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedDeparture,
                decoration: InputDecoration(labelText: 'Departure Airport'),
                items: predefinedAirports.map((airport) {
                  return DropdownMenuItem(
                    value: airport,
                    child: Text(airport),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedDeparture = value;
                  });
                },
              ),
              SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _selectedArrival,
                decoration: InputDecoration(labelText: 'Arrival Airport'),
                items: predefinedAirports.map((airport) {
                  return DropdownMenuItem(
                    value: airport,
                    child: Text(airport),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedArrival = value;
                  });
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _applyFilters();
                Navigator.pop(context);
              },
              child: Text('Apply'),
            ),
          ],
        );
      },
    );
  }

  void _applyFilters() {
    _fetchFlights(departure: _selectedDeparture, arrival: _selectedArrival);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB3D1FF),
      appBar: AppBar(
        backgroundColor: Color(0xFFB3D1FF),
        title: Text(
          'Flight List',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          // Search Button
          IconButton(
            icon: Icon(Icons.search, size: 26),
            onPressed: _openSearch,
          ),
        ],
      ),
      drawer: _buildDashboard(), // Dashboard (Drawer)
      body: Column(
        children: [
          if (_lastUpdated != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Last Updated: ${_lastUpdated!.toLocal()}',
                style: TextStyle(fontSize: 12, color: Colors.black),
              ),
            ),
          Expanded(
            child: RefreshControl(
              onRefresh: _fetchFlights,
              child: FutureBuilder<List<Flight>>(
                future: futureFlights,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Failed to load flights',
                            style: TextStyle(color: Colors.red),
                          ),
                          SizedBox(height: 10),
                          Text('Error: ${snapshot.error}'),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('No flights available'));
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final flight = snapshot.data![index];
                        return FlightListItem(flight: flight);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Dashboard (Drawer)
  Widget _buildDashboard() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Color(0xFFB3D1FF),
            ),
            child: Text(
              'Dashboard',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              _autoRefreshEnabled ? Icons.toggle_on : Icons.toggle_off,
              color: _autoRefreshEnabled ? Colors.green : Colors.grey,
              size: 30,
            ),
            title: Text('Auto Refresh'),
            onTap: _toggleAutoRefresh,
          ),
          ListTile(
            leading: Icon(Icons.refresh, size: 26),
            title: Text('Refresh Flights'),
            onTap: _fetchFlights,
          ),
          ListTile(
            leading: Icon(Icons.filter_alt, size: 26),
            title: Text('Filter Flights'),
            onTap: _openFilterDialog,
          ),
        ],
      ),
    );
  }
}