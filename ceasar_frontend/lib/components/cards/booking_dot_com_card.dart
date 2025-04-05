// lib/card/booking_card_dot_com.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingCard extends StatelessWidget {
  final String _imageUrl;
  final String _hotelUrl;
  final String _title;
  final String _rating;
  final String _reviewCount;
  final String _reviewComment;
  final String _price;
  final String _breakfastIncluded;

  const BookingCard({
    super.key,
    required String imageUrl,
    required String hotelUrl,
    required String title,
    required String rating,
    required String reviewCount,
    required String reviewComment,
    required String price,
    required String breakfastIncluded,
  })  : _imageUrl = imageUrl,
        _hotelUrl = hotelUrl,
        _title = title,
        _rating = rating,
        _reviewCount = reviewCount,
        _reviewComment = reviewComment,
        _price = price,
        _breakfastIncluded = breakfastIncluded;

  /// Factory constructor to create a [BookingCard] instance from JSON data.
  factory BookingCard.fromJson(Map<String, dynamic> json) {
    return BookingCard(
      imageUrl: json["image_url"] ?? "",
      hotelUrl: json["hotel url"] ?? "",
      title: json["title"] ?? "",
      rating: json["rating"] ?? "",
      reviewCount: json["review count"] ?? "",
      reviewComment: json["review comment"] ?? "",
      price: json["price"] ?? "",
      breakfastIncluded: json["Breakfast included"] ?? "False",
    );
  }

  /// Static method to create a list of [BookingCard] widgets from a JSON list.
  static List<BookingCard> createCards(List<dynamic> data) {
    return data.map((item) => BookingCard.fromJson(item)).toList();
  }

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(_hotelUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $_hotelUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                  "Do you want to proceed to the Booking.com listing?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
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
      child: SizedBox(
        width: 380,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        _imageUrl,
                        height: 200,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(child: CircularProgressIndicator());
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return const Center(
                            child: Icon(Icons.image_not_supported, size: 50),
                          );
                        },
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              _rating,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      if (_reviewComment.isNotEmpty)
                        Text(
                          _reviewComment,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: _breakfastIncluded == "True" 
                                  ? Colors.green[900] 
                                  : Colors.red[900],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  _breakfastIncluded == "True"
                                      ? Icons.restaurant
                                      : Icons.no_meals,
                                  color: Colors.white,
                                  size: 16,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _breakfastIncluded == "True"
                                      ? "Breakfast Included"
                                      : "No Breakfast",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '₹$_price',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '$_reviewCount reviews',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ).animate().fade(duration: 300.ms).slideX(),
      ),
    );
  }
}

/// Example data generator for [BookingCard] widgets.
List<BookingCard> getBookingCards(dynamic response) {
  final List<Map<String, dynamic>> scrapedDataList = response;
  return scrapedDataList.map((data) => BookingCard.fromJson(data)).toList();
}

class BookingCardGrid extends StatelessWidget {
  final List<BookingCard> cards;

  const BookingCardGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(
          width: MediaQuery.of(context).size.width * 1,
          child: cards[index],
        ),
      ),
    );
  }
}
