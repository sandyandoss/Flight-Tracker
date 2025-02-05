import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:weather_icons/weather_icons.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final String apiKey = 'YOUR_API_KEY'; // Replace with your OpenWeatherMap API key
  final TextEditingController _searchController = TextEditingController();
  Map<String, dynamic>? _weatherData;
  bool _isLoading = false;
  String _errorMessage = '';
  String _unit = 'metric';
  List<Map<String, dynamic>> _hourlyForecast = [];

  Future<void> _fetchWeather(String city) async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
      _hourlyForecast = [];
    });

    try {
      final weatherResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/weather?q=$city&units=$_unit&appid=$apiKey'));

      if (weatherResponse.statusCode == 200) {
        final weatherData = json.decode(weatherResponse.body);
        await _fetchForecast(city);
        setState(() {
          _weatherData = weatherData;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'City not found!';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Connection error!';
        _isLoading = false;
      });
    }
  }

  Future<void> _fetchForecast(String city) async {
    try {
      final forecastResponse = await http.get(Uri.parse(
          'https://api.openweathermap.org/data/2.5/forecast?q=$city&units=$_unit&appid=$apiKey'));

      if (forecastResponse.statusCode == 200) {
        final forecastData = json.decode(forecastResponse.body);
        final List<dynamic> forecastList = forecastData['list'];

        setState(() {
          _hourlyForecast = forecastList.take(8).map((item) {
            final dateTime = DateTime.parse(item['dt_txt']);
            return {
              'time': '${dateTime.hour.toString().padLeft(2, '0')}:00',
              'temp': item['main']['temp'],
              'icon': _getWeatherIcon(item['weather'][0]['id'])
            };
          }).toList();
        });
      }
    } catch (e) {
      print('Forecast error: $e');
    }
  }

  IconData _getWeatherIcon(int condition) {
    if (condition < 300) return WeatherIcons.thunderstorm;
    if (condition < 400) return WeatherIcons.rain;
    if (condition < 600) return WeatherIcons.showers;
    if (condition < 700) return WeatherIcons.snow;
    if (condition < 800) return WeatherIcons.fog;
    if (condition == 800) return WeatherIcons.day_sunny;
    return WeatherIcons.cloudy;
  }

  void _toggleUnits() {
    setState(() {
      _unit = _unit == 'metric' ? 'imperial' : 'metric';
      if (_weatherData != null) {
        _fetchWeather(_weatherData!['name']);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather',
            style: TextStyle(
              color: Colors.blue[800],
              fontWeight: FontWeight.bold,
              fontSize: 24,
            )),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.location_on, color: Colors.blue[600]),
            onPressed: () {/* Add geolocation */},
          )
        ],
      ),
      body: AnimatedContainer(
        duration: Duration(seconds: 1),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFF0F7FF)],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView( // Wrap the Column in a SingleChildScrollView
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  _buildSearchBar(),
                  SizedBox(height: 30),
                  if (_isLoading) _buildLoadingIndicator(),
                  if (_errorMessage.isNotEmpty) _buildErrorDisplay(),
                  if (_weatherData != null && !_isLoading) ...[
                    _buildWeatherHeader(),
                    SizedBox(height: 30),
                    _buildHourlyForecast(),
                    SizedBox(height: 30),
                    _buildWeatherGrid(), // Removed Expanded
                  ],
                  SizedBox(height: 20), // Add spacing at the bottom
                  _buildUnitToggle(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: TextField(
        controller: _searchController,
        decoration: InputDecoration(
          hintText: 'Search city...',
          hintStyle: TextStyle(color: Colors.blueGrey[300]),
          prefixIcon: Icon(Icons.search, color: Colors.blue[400]),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        ),
        style: TextStyle(color: Colors.blue[800], fontSize: 16),
        onSubmitted: (value) => _fetchWeather(value),
      ),
    ).animate().slideX(duration: 500.ms);
  }

  Widget _buildLoadingIndicator() {
    return CircularProgressIndicator(
      color: Colors.blue[400],
    ).animate(onPlay: (controller) => controller.repeat()).shimmer();
  }

  Widget _buildErrorDisplay() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.redAccent.withOpacity(0.1),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, color: Colors.redAccent),
          SizedBox(width: 10),
          Text(
            _errorMessage,
            style: TextStyle(color: Colors.redAccent),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherHeader() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 15,
            spreadRadius: 5,
          )
        ],
      ),
      child: Column(
        children: [
          Text(
            _weatherData!['name'],
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.blue[900],
            ),
          ),
          SizedBox(height: 10),
          Text(
            '${_weatherData!['main']['temp'].round()}°${_unit == 'metric' ? 'C' : 'F'}',
            style: TextStyle(
              fontSize: 56,
              fontWeight: FontWeight.w300,
              color: Colors.blue[800],
            ),
          ),
          SizedBox(height: 10),
          Text(
            _weatherData!['weather'][0]['description'],
            style: TextStyle(
              fontSize: 18,
              color: Colors.blue[600],
            ),
          ),
          SizedBox(height: 15),
          Icon(
            _getWeatherIcon(_weatherData!['weather'][0]['id']),
            size: 80,
            color: Colors.blue[400],
          ),
        ],
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildHourlyForecast() {
    return Container(
      height: 120, // Fixed height to prevent overflow
      child: ListView.builder(
        shrinkWrap: true,
        physics: ClampingScrollPhysics(),
        scrollDirection: Axis.horizontal,
        itemCount: _hourlyForecast.length,
        itemBuilder: (context, index) {
          final hour = _hourlyForecast[index];
          return Container(
            width: 90,
            margin: EdgeInsets.only(right: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: Colors.blue[50]!),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.withOpacity(0.05),
                  blurRadius: 10,
                  spreadRadius: 2,
                )
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  hour['time'],
                  style: TextStyle(
                    color: Colors.blue[700],
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                ),
                SizedBox(height: 8),
                Icon(hour['icon'], size: 30, color: Colors.blue[400]),
                SizedBox(height: 8),
                Text(
                  '${hour['temp'].round()}°',
                  style: TextStyle(
                    color: Colors.blue[800],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildWeatherGrid() {
    return GridView.count(
      shrinkWrap: true, // Add this
      physics: NeverScrollableScrollPhysics(), // Prevent nested scrolling
      crossAxisCount: 2,
      childAspectRatio: 1.4,
      crossAxisSpacing: 15,
      mainAxisSpacing: 15,
      padding: EdgeInsets.symmetric(horizontal: 8),
      children: [
        _buildWeatherCard('Feels Like', '${_weatherData!['main']['feels_like'].round()}°',
            WeatherIcons.thermometer, Colors.blue[400]!),
        _buildWeatherCard('Humidity', '${_weatherData!['main']['humidity']}%',
            WeatherIcons.humidity, Colors.blue[400]!),
        _buildWeatherCard('Wind', '${_weatherData!['wind']['speed'].round()} ${_unit == 'metric' ? 'm/s' : 'mph'}',
            WeatherIcons.strong_wind, Colors.blue[400]!),
        _buildWeatherCard('Pressure', '${_weatherData!['main']['pressure']} hPa',
            WeatherIcons.barometer, Colors.blue[400]!),
      ],
    );
  }

  Widget _buildWeatherCard(String title, String value, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 30, color: color),
          ),
          SizedBox(height: 15),
          Text(
            title,
            style: TextStyle(
              color: Colors.blue[600],
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 5),
          Text(
            value,
            style: TextStyle(
              color: Colors.blue[800],
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUnitToggle() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 2,
          )
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildUnitButton('°C', 'metric'),
          _buildUnitButton('°F', 'imperial'),
        ],
      ),
    );
  }

  Widget _buildUnitButton(String label, String unit) {
    final isActive = _unit == unit;
    return Material(
      color: isActive ? Colors.blue[50]! : Colors.transparent,
      borderRadius: BorderRadius.circular(30),
      child: InkWell(
        onTap: () => _toggleUnits(),
        borderRadius: BorderRadius.circular(30),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 25, vertical: 12),
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? Colors.blue[800]! : Colors.blue[400]!,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}