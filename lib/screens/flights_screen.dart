import 'dart:async';
import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../services/api_service.dart';
import '../widgets/flight_list_item.dart';
import '../widgets/refresh_control.dart';
import 'filter_flight_screen.dart'; // Import the search page

class FlightsScreen extends StatefulWidget {
  @override
  _FlightsScreenState createState() => _FlightsScreenState();
}

class _FlightsScreenState extends State<FlightsScreen> {
  late Future<List<Flight>> futureFlights;
  Timer? _timer;
  bool _autoRefreshEnabled = true;
  DateTime? _lastUpdated;

  @override
  void initState() {
    super.initState();
    _fetchFlights();
  }

  void _fetchFlights() {
    setState(() {
      futureFlights = ApiService().fetchFlights();
      _lastUpdated = DateTime.now();
    });
  }

 /* void _openSearch() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchFlightScreen(),
      ),
    );
  } */

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

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 10), (timer) {
      _fetchFlights();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
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
      /*  actions: [
          IconButton(
            icon: Icon(Icons.search, size: 26),
            onPressed: _openSearch,
          ),
        ],*/
      ),
      drawer: _buildDashboard(), // Dashboard Drawer
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
            onTap: () {
              // Implement filter functionality if needed
            },
          ),
        ],
      ),
    );
  }
}
