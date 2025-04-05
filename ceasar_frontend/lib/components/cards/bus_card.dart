import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BusCard extends StatelessWidget {
  final String busName;
  final String busType;
  final String departureTime;
  final String departureDate;
  final String arrivalTime;
  final String arrivalDate;
  final String duration;
  final String finalPrice;
  final String rating;
  final String seatsAvailable;
  final String url;

  const BusCard({
    super.key,
    required this.busName,
    required this.busType,
    required this.departureTime,
    required this.departureDate,
    required this.arrivalTime,
    required this.arrivalDate,
    required this.duration,
    required this.finalPrice,
    required this.rating,
    required this.seatsAvailable,
    required this.url,
  });
  factory BusCard.fromJson(Map<String, dynamic> json) {
    return BusCard(
      busName: json["bus_name"] ?? "",
      busType: json["bus_type"] ?? "",
      departureTime: json["departure_time"] ?? "",
      departureDate: json["departure_date"] ?? "",
      arrivalTime: json["arrival_time"] ?? "",
      arrivalDate: json["arrival_date"] ?? "",
      duration: json["duration"] ?? "",
      finalPrice: json["final_price"] ?? "",
      rating: json["rating"] ?? "",
      seatsAvailable: json["seats_available"] ?? "",
      url: json["url"] ?? "",
    );
  }

  /// Static method to create a list of BusCards from a JSON list.
  static List<BusCard> createCards(List<dynamic> data) {
    return data.map((item) => BusCard.fromJson(item)).toList();
  }

  /// Launches the URL in an external application.
  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final double cardWidth = MediaQuery.of(context).size.width * 0.8;

    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text("Do you want to proceed to the bus website?"),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: const Text("Back"),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text("Ok"),
                ),
              ],
            );
          },
        ).then((confirmed) {
          if (confirmed == true) {
            _launchUrl();
          }
        });
      },
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        elevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        child: SizedBox(
          width: cardWidth,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Color(0xFF23272A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header: Bus Name and Type with icons.
                Row(
                  children: [
                    const Icon(Icons.directions_bus,
                        color: Colors.lightBlueAccent),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        busName,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.category, size: 16, color: Colors.white70),
                    const SizedBox(width: 4),
                    Text(
                      busType,
                      style: TextStyle(fontSize: 14, color: Colors.grey[300]),
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 20, thickness: 1),
                // Departure and Arrival information.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Departure
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.departure_board,
                                color: Colors.greenAccent, size: 20),
                            const SizedBox(width: 4),
                            const Text(
                              "Departure",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              "$departureTime",
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.date_range,
                                size: 16, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              "$departureDate",
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Arrival
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.share_arrival_time,
                                color: Colors.redAccent, size: 20),
                            const SizedBox(width: 4),
                            const Text(
                              "Arrival",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.access_time,
                                size: 16, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              "$arrivalTime",
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.date_range,
                                size: 16, color: Colors.white70),
                            const SizedBox(width: 4),
                            Text(
                              "$arrivalDate",
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const Divider(color: Colors.white24, height: 20, thickness: 1),
                // Duration, Rating, Seats Available, and Price.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Duration and Rating
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.timelapse,
                                color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              "Duration: $duration",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.orange, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              rating,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                    // Seats and Price
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.event_seat,
                                color: Colors.lightGreenAccent, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              "Seats: $seatsAvailable",
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.currency_rupee,
                                color: Colors.lightBlueAccent, size: 18),
                            const SizedBox(width: 2),
                            Text(
                              finalPrice,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ).animate().fade(duration: 300.ms).slideX(),
    );
  }
}

/// Returns a list of BusCard widgets using sample bus data.
List<BusCard> getBusCards(List<Map<String, String>> response) {
  final List<Map<String, String>> busDataList = response;
  return busDataList.map((response) {
    return BusCard(
      busName: response["bus_name"] ?? "",
      busType: response["bus_type"] ?? "",
      departureTime: response["departure_time"] ?? "",
      departureDate: response["departure_date"] ?? "",
      arrivalTime: response["arrival_time"] ?? "",
      arrivalDate: response["arrival_date"] ?? "",
      duration: response["duration"] ?? "",
      finalPrice: response["final_price"] ?? "",
      rating: response["rating"] ?? "",
      seatsAvailable: response["seats_available"] ?? "",
      url: response["url"] ?? "",
    );
  }).toList();
}

class BusCardGrid extends StatelessWidget {
  final List<BusCard> cards;

  const BusCardGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 285,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        // Adds a 12 pixel gap between each BusCard in the horizontal list.
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: cards[index],
        ),
      ),
    );
  }
}

// class BusListScreen extends StatefulWidget {
//   @override
//   _BusListScreenState createState() => _BusListScreenState();
// }

// class _BusListScreenState extends State<BusListScreen> {
//   List<Map<String, String>> _busData = []; // Your original bus data
//   String? _selectedSortAttribute;
//   bool _ascending = true;

//   void _sortBusCards(String attribute) {
//     setState(() {
//       _selectedSortAttribute = attribute;
//       _busData.sort((a, b) {
//         final aValue = a[attribute] ?? '';
//         final bValue = b[attribute] ?? '';

//         // Handle different data types
//         if (attribute == 'final_price' ||
//             attribute == 'rating' ||
//             attribute == 'seats_available') {
//           final aNum = double.tryParse(aValue) ?? 0;
//           final bNum = double.tryParse(bValue) ?? 0;
//           return _ascending ? aNum.compareTo(bNum) : bNum.compareTo(aNum);
//         } else if (attribute == 'departure_time' ||
//             attribute == 'arrival_time') {
//           return _compareTime(aValue, bValue);
//         } else if (attribute == 'duration') {
//           return _compareDuration(aValue, bValue);
//         } else {
//           return _ascending
//               ? aValue.compareTo(bValue)
//               : bValue.compareTo(aValue);
//         }
//       });
//       _ascending = !_ascending; // Toggle sort order for next time
//     });
//   }

//   int _compareTime(String a, String b) {
//     final aParts = a.split(':').map(int.parse).toList();
//     final bParts = b.split(':').map(int.parse).toList();
//     final aMinutes = aParts[0] * 60 + aParts[1];
//     final bMinutes = bParts[0] * 60 + bParts[1];
//     return _ascending
//         ? aMinutes.compareTo(bMinutes)
//         : bMinutes.compareTo(aMinutes);
//   }

//   int _compareDuration(String a, String b) {
//     final parse = (String d) => d
//         .split(' ')
//         .map((v) => int.parse(v.replaceAll(RegExp(r'[^0-9]'), '')))
//         .toList();
//     final aParts = parse(a);
//     final bParts = parse(b);
//     final aTotal = aParts[0] * 60 + (aParts.length > 1 ? aParts[1] : 0);
//     final bTotal = bParts[0] * 60 + (bParts.length > 1 ? bParts[1] : 0);
//     return _ascending ? aTotal.compareTo(bTotal) : bTotal.compareTo(aTotal);
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bus List'),
//         actions: [
//           PopupMenuButton<String>(
//             onSelected: _sortBusCards,
//             itemBuilder: (context) => [
//               'bus_name',
//               'bus_type',
//               'departure_time',
//               'arrival_time',
//               'duration',
//               'final_price',
//               'rating',
//               'seats_available',
//             ]
//                 .map((attr) => PopupMenuItem(
//                       value: attr,
//                       child: Text('Sort by ${attr.replaceAll('_', ' ')}'),
//                     ))
//                 .toList(),
//             icon: Icon(Icons.sort),
//           ),
//         ],
//       ),
//       body: BusCardGrid(cards: getBusCards(_busData)),
//     );
//   }
// }
