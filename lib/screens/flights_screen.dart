import 'dart:async';
import 'package:flutter/material.dart';
import '../models/flight.dart';
import '../services/api_service.dart';
import '../widgets/refresh_control.dart';
import 'flight_detail_screen.dart';
import 'filter_flight_screen.dart'; // Make sure to import your filter screen

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
    _startTimerIfNeeded();
  }

  void _fetchFlights() {
    setState(() {
      futureFlights = ApiService().fetchFlights();
      _lastUpdated = DateTime.now();
    });
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

  void _startTimerIfNeeded() {
    if (_autoRefreshEnabled) {
      _startTimer();
    }
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
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5A7DB8), Color(0xFF7AA3D8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
          ),
        ),
        title: Text(
          'Flight List',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      drawer: _buildDashboard(),
      body: Column(
        children: [
          if (_lastUpdated != null) _buildLastUpdatedInfo(),
          Expanded(
            child: RefreshControl(
              onRefresh: _fetchFlights,
              child: FutureBuilder<List<Flight>>(
                future: futureFlights,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.indigoAccent),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return _buildErrorWidget(snapshot.error);
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return _buildNoFlightsWidget();
                  } else {
                    return _buildFlightList(snapshot.data!);
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLastUpdatedInfo() {
    return Container(
      margin: EdgeInsets.all(12),
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.update, color: Colors.indigo, size: 20),
          SizedBox(width: 8),
          Text(
            'Last Updated: ${_lastUpdated!.toLocal()}',
            style: TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorWidget(Object? error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, color: Colors.red, size: 50),
          SizedBox(height: 10),
          Text(
            'Failed to load flights',
            style: TextStyle(color: Colors.red, fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            'Error: $error',
            style: TextStyle(color: Colors.grey[800], fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildNoFlightsWidget() {
    return Center(
      child: Text(
        'No flights available',
        style: TextStyle(color: Colors.grey[800], fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildFlightList(List<Flight> flights) {
    return ListView.builder(
      padding: EdgeInsets.symmetric(vertical: 12),
      itemCount: flights.length,
      itemBuilder: (context, index) {
        final flight = flights[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => FlightDetailScreen(flight: flight)),
            );
          },
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF5A7DB8), Color(0xFF7AA3D8)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 10),
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                '${flight.airline} ${flight.flightNumber}',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: '🛫 ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextSpan(
                      text: '${flight.origin}',
                      style: TextStyle(color: Colors.orangeAccent, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' → 🛬 ',
                      style: TextStyle(color: Colors.white70),
                    ),
                    TextSpan(
                      text: '${flight.destination}',
                      style: TextStyle(color: Colors.lightGreenAccent, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: '\n${flight.departureTime} - ${flight.arrivalTime}',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                  ],
                ),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white, size: 24),
            ),
          ),
        );
      },
    );
  }


  Widget _buildDashboard() {
    return Drawer(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF5A7DB8), Color(0xFF7AA3D8)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            _buildDrawerHeader(),
            _buildDrawerItem(
              icon: _autoRefreshEnabled ? Icons.toggle_on : Icons.toggle_off,
              title: 'Auto Refresh',
              onTap: _toggleAutoRefresh,
            ),
            _buildDrawerItem(icon: Icons.refresh, title: 'Refresh Flights', onTap: _fetchFlights),
            _buildDrawerItem(
              icon: Icons.filter_alt,
              title: 'Filter Flights',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FilterFlightScreen()),
                );
              },
            ),
            Divider(color: Colors.white.withOpacity(0.3), height: 20),
            _buildDrawerItem(icon: Icons.settings, title: 'Settings'),
            _buildDrawerItem(icon: Icons.help_outline, title: 'Help & Support'),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return Container(
      height: 200,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF5A7DB8), Color(0xFF7AA3D8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.airplanemode_active, size: 50, color: Colors.white),
          SizedBox(height: 10),
          Text(
            'Flight Dashboard',
            style: TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Text(
            'Manage your flights',
            style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return ListTile(
      leading: Icon(icon, size: 26, color: Colors.white),
      title: Text(
        title,
        style: TextStyle(color: Colors.white, fontSize: 16),
      ),
      onTap: onTap,
    );
  }
}
