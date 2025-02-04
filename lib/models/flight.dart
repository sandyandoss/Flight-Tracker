class Flight {
  final String flightNumber;
  final String origin;
  final String destination;
  final String departureTime;
  final String arrivalTime;
  final String status;

  Flight({
    required this.flightNumber,
    required this.origin,
    required this.destination,
    required this.departureTime,
    required this.arrivalTime,
    required this.status,
  });

  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightNumber: json['flight']['iata'] ?? 'Unknown',
      origin: json['departure']['iata'] ?? 'Unknown',
      destination: json['arrival']['iata'] ?? 'Unknown',
      departureTime: json['departure']['scheduled'] ?? 'Unknown',
      arrivalTime: json['arrival']['scheduled'] ?? 'Unknown',
      status: json['flight_status'] ?? 'Unknown',
    );
  }
}
  /* Example of JSON
  {
  "flight": {
    "iata": "AA123"
  },
  "departure": {
    "airport": "LAX",
    "scheduled": "2023-10-01T12:00:00Z"
  },
  "arrival": {
    "airport": "JFK",
    "scheduled": "2023-10-01T20:00:00Z"
  },
  "flight_status": "On Time"
} */


/*  factory Flight.fromJson(Map<String, dynamic> json) {
    return Flight(
      flightNumber: json['flight']['iata'],
      origin: json['departure']['airport'],
      destination: json['arrival']['airport'],
      departureTime: json['departure']['scheduled'],
      arrivalTime: json['arrival']['scheduled'],
      status: json['flight_status'],
    );
  }
} */

  /*
  Printing the entire JSON to inspect it

  factory Flight.fromJson(Map<String, dynamic> json) {
    print(json);
    return Flight(
      flightNumber: json['flight']?['iata'] ?? 'Unknown',
      origin: json['departure']?['airport'] ?? 'Unknown',
      destination: json['arrival']?['airport'] ?? 'Unknown',
      departureTime: json['departure']?['scheduled'] ?? 'Unknown',
      arrivalTime: json['arrival']?['scheduled'] ?? 'Unknown',
      status: json['flight_status'] ?? 'Unknown',
    );
  }
} */