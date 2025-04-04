import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FlightCompareCard extends StatelessWidget {
  final String airline;
  final String airlineLogo;
  final String departureTime;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCity;
  final String duration;
  final String price;
  final String fareType;
  final String layover;
  final String url;
  final String? provider1Name;
  final String? provider1Price;
  final String? provider1Url;
  final String? provider2Name;
  final String? provider2Price;
  final String? provider2Url;

  const FlightCompareCard({
    super.key,
    required this.airline,
    required this.airlineLogo,
    required this.departureTime,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCity,
    required this.duration,
    required this.price,
    required this.fareType,
    required this.layover,
    required this.url,
    this.provider1Name,
    this.provider1Price,
    this.provider1Url,
    this.provider2Name,
    this.provider2Price,
    this.provider2Url,
  });

  /// Factory method to create a FlightCompareCard from a JSON object.
  factory FlightCompareCard.fromJson(Map<String, dynamic> json) {
    return FlightCompareCard(
      airline: json['airline'] ?? 'Unknown Airline',
      airlineLogo: json['airline_logo'] ?? '',
      departureTime: json['departure_time'] ?? '--:--',
      departureCity: json['departure_city'] ?? 'Unknown City',
      arrivalTime: json['arrival_time'] ?? '--:--',
      arrivalCity: json['arrival_city'] ?? 'Unknown City',
      duration: json['duration'] ?? '',
      price: json['price'] ?? 'N/A',
      fareType: json['fare_type'] ?? 'Economy',
      layover: json['layover'] ?? 'direct',
      url: json['url'] ?? '',
      provider1Name: json['provider1_name']?.toString(),
      provider1Price: json['provider1_price']?.toString(),
      provider1Url: json['provider1_url']?.toString(),
      provider2Name: json['provider2_name']?.toString(),
      provider2Price: json['provider2_price']?.toString(),
      provider2Url: json['provider2_url']?.toString(),
    );
  }

  /// Static method to create a list of FlightCompareCards from a JSON list.
  static List<FlightCompareCard> createCards(List<dynamic> data) {
    return data.map((item) => FlightCompareCard.fromJson(item)).toList();
  }

  /// URL launcher helper method.
  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  /// Helper widget to build the provider price block.
  Widget _buildProviderPrice(String name, String price, String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.open_in_new, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Airline logo and name
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Image.network(
                    airlineLogo,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.airplanemode_active, size: 40),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        airline,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        fareType,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Flight departure and arrival info
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departureCity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        departureTime,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.flight_takeoff, color: Colors.white, size: 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrivalCity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        arrivalTime,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Flight duration and layover indicator
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(duration, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: layover.toLowerCase() == "direct"
                        ? Colors.green[800]
                        : Colors.orange[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    layover.toLowerCase() == "direct" ? "Non-stop" : "Layover",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // Price block and providers list
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _launchUrl(url),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Cheapflights",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (provider1Name != null && provider1Price != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildProviderPrice(
                      provider1Name!,
                      provider1Price!,
                      provider1Url ?? "",
                    ),
                  ),
                if (provider2Name != null && provider2Price != null)
                  _buildProviderPrice(
                    provider2Name!,
                    provider2Price!,
                    provider2Url ?? "",
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 300.ms).slideX();
  }
}

/// Convenience method to generate a list of FlightCompareCards from JSON response.
List<FlightCompareCard> getFlightCompareCards(
  List<Map<String, dynamic>> response,
) {
  return response.map((flight) {
    return FlightCompareCard(
      airline: flight["airline"] ?? "Unknown Airline",
      airlineLogo: flight["airline_logo"] ?? "",
      departureTime: flight["departure_time"] ?? "--:--",
      departureCity: flight["departure_city"] ?? "",
      arrivalTime: flight["arrival_time"] ?? "--:--",
      arrivalCity: flight["arrival_city"] ?? "",
      duration: flight["duration"] ?? "",
      price: flight["price"] ?? "₹—",
      fareType: flight["fare_type"] ?? "Economy",
      layover: flight["layover"] ?? "direct",
      url: flight["url"] ?? "",
      provider1Name: flight["provider1_name"]?.toString(),
      provider1Price: flight["provider1_price"]?.toString(),
      provider1Url: flight["provider1_url"]?.toString(),
      provider2Name: flight["provider2_name"]?.toString(),
      provider2Price: flight["provider2_price"]?.toString(),
      provider2Url: flight["provider2_url"]?.toString(),
    );
  }).toList();
}

/// Static flight data for testing purposes.
final Map<String, dynamic> staticFlightData = {
  'type': 'flightCompare',
  'data': [
    // Flight data goes here
  ]
};
