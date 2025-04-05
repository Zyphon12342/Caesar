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
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Colors.black, Color(0xFF23272A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row: Airline logo, name and fare type.
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(6),
                  child: Image.network(
                    airlineLogo,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.airplanemode_active, size: 40),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        airline,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.confirmation_number,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            fareType,
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 12),
            // Flight departure and arrival info with icons.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 18, color: Colors.greenAccent),
                          const SizedBox(width: 4),
                          Text(
                            departureCity,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            departureTime,
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.flight_takeoff, color: Colors.white, size: 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.location_on,
                              size: 18, color: Colors.redAccent),
                          const SizedBox(width: 4),
                          Text(
                            arrivalCity,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(Icons.access_time,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            arrivalTime,
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Flight duration and layover indicator with icons.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(
                      duration,
                      style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    ),
                  ],
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: layover.toLowerCase() == "direct"
                        ? Colors.green[800]
                        : Colors.orange[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        layover.toLowerCase() == "direct"
                            ? Icons.flight
                            : Icons.airplanemode_active,
                        size: 14,
                        color: Colors.white,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        layover.toLowerCase() == "direct"
                            ? "Non-stop"
                            : "Layover",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 12),
            // Price block and provider options.
            GestureDetector(
              onTap: () => _launchUrl(url),
              child: Container(
                padding: const EdgeInsets.all(14),
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
            const SizedBox(height: 16),
            // Provider options arranged using a Wrap widget.
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                if (provider1Name != null && provider1Price != null)
                  _buildProviderPrice(
                    provider1Name!,
                    provider1Price!,
                    provider1Url ?? "",
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
  return response.map((flight) => FlightCompareCard.fromJson(flight)).toList();
}

/// FlightCompareCardGrid remains unchanged.
class FlightCompareCardGrid extends StatelessWidget {
  final List<FlightCompareCard> cards;

  const FlightCompareCardGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.85,
          child: cards[index],
        ),
      ),
    );
  }
}
