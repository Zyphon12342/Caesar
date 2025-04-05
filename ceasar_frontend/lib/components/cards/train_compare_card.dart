import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// Model for each train class details.
class TrainClass {
  final String type;
  final String price;
  final String availability;

  TrainClass({
    required this.type,
    required this.price,
    required this.availability,
  });

  factory TrainClass.fromJson(Map<String, dynamic> json) {
    return TrainClass(
      type: json['class'] ?? 'Unknown',
      price: json['price'] ?? '',
      availability: json['availability'] ?? '',
    );
  }
}

/// Main Train Compare Card widget.
class TrainCompareCard extends StatelessWidget {
  final String trainName;
  final String startTime;
  final String startDate;
  final String startLocation;
  final String endTime;
  final String endDate;
  final String endLocation;
  final String duration;
  final List<TrainClass> classes;
  final String url;

  const TrainCompareCard({
    super.key,
    required this.trainName,
    required this.startTime,
    required this.startDate,
    required this.startLocation,
    required this.endTime,
    required this.endDate,
    required this.endLocation,
    required this.duration,
    required this.classes,
    required this.url,
  });

  /// Factory constructor to create a TrainCompareCard from JSON.
  factory TrainCompareCard.fromJson(Map<String, dynamic> json) {
    var classList = <TrainClass>[];
    if (json['classes'] != null && json['classes'] is List) {
      classList = (json['classes'] as List)
          .map((item) => TrainClass.fromJson(item))
          .toList();
    }
    return TrainCompareCard(
      trainName: json['train_name'] ?? 'Unknown Train',
      startTime: json['start_time'] ?? '--:--',
      startDate: json['start_date'] ?? '',
      startLocation: json['start_location'] ?? 'Unknown Station',
      endTime: json['end_time'] ?? '--:--',
      endDate: json['end_date'] ?? '',
      endLocation: json['end_location'] ?? 'Unknown Station',
      duration: json['duration'] ?? '',
      classes: classList,
      url: json['url'] ?? '',
    );
  }

  /// Static method to create a list of TrainCompareCards from JSON list.
  static List<TrainCompareCard> createCards(List<dynamic> data) {
    return data.map((item) => TrainCompareCard.fromJson(item)).toList();
  }

  /// URL launcher helper method.
  Future<void> _launchUrl(BuildContext context) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not launch booking URL')),
      );
    }
  }

  /// Helper widget to build the train class block.
  Widget _buildClassBlock(TrainClass trainClass) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      margin: const EdgeInsets.only(right: 8, bottom: 8),
      decoration: BoxDecoration(
        color: Colors.grey[800],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[700]!),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            trainClass.type,
            style: TextStyle(
              color: Colors.grey[400],
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trainClass.price,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            trainClass.availability,
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
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
        padding: const EdgeInsets.all(25),
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
            // Header row: Train icon and name.
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.train,
                    color: Colors.black,
                    size: 40,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    trainName,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 12),
            // Departure and Arrival details.
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Departure Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.location_on,
                              size: 18, color: Colors.greenAccent),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              startLocation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                            "$startTime $startDate",
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.arrow_forward, color: Colors.white, size: 28),
                // Arrival Info
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
                          Flexible(
                            child: Text(
                              endLocation,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                              overflow: TextOverflow.ellipsis,
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
                            "$endTime $endDate",
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
            // Duration information.
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
            const SizedBox(height: 20),
            const Divider(color: Colors.white24, thickness: 1),
            const SizedBox(height: 12),
            // Available classes for the train.
            Text(
              "Available Classes",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: classes
                  .map((trainClass) => _buildClassBlock(trainClass))
                  .toList(),
            ),
            const SizedBox(height: 20),
            // "Book Tickets" button.
            Center(
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepOrangeAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.open_in_new),
                label: const Text("Book Tickets"),
                onPressed: () => _launchUrl(context),
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 300.ms).slideX();
  }
}

/// Grid widget for displaying TrainCompareCards horizontally.
class TrainCompareCardGrid extends StatelessWidget {
  final List<TrainCompareCard> cards;

  const TrainCompareCardGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 600,
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
