// lib/card/booking_card_dot_com.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class BookingCard extends StatelessWidget {
  final String imageUrl;
  final String hotelUrl;
  final String title;
  final String rating;
  final String reviewCount;
  final String reviewComment;
  final String price;
  final String breakfastIncluded;

  const BookingCard({
    super.key,
    required this.imageUrl,
    required this.hotelUrl,
    required this.title,
    required this.rating,
    required this.reviewCount,
    required this.reviewComment,
    required this.price,
    required this.breakfastIncluded,
  });

  /// Factory constructor to create a [BookingCard] instance from JSON data.
  factory BookingCard.fromJson(Map<String, dynamic> json) => BookingCard(
        imageUrl: json["image_url"] ?? "",
        hotelUrl: json["hotel url"] ?? "",
        title: json["title"] ?? "",
        rating: json["rating"] ?? "",
        reviewCount: json["review count"] ?? "",
        reviewComment: json["review comment"] ?? "",
        price: json["price"] ?? "",
        breakfastIncluded: json["Breakfast included"] ?? "False",
      );

  /// Static method to create a list of [BookingCard] widgets from a JSON list.
  static List<BookingCard> createCards(List<dynamic> data) =>
      data.map((item) => BookingCard.fromJson(item)).toList();

  Future<void> _launchUrl() async {
    final uri = Uri.parse(hotelUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $hotelUrl");
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Confirmation"),
            content: const Text("Proceed to Booking.com listing?"),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text("Back")),
              TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text("Ok")),
            ],
          ),
        );
        if (confirmed == true) _launchUrl();
      },
      child: IntrinsicHeight(
        child: SizedBox(
          width: 240, // Base width but parent can override
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 3,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.black, Color(0xFF23272A)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image section with fixed height
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 120, // Fixed height for image
                      child: Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (ctx, child, progress) => progress ==
                                null
                            ? child
                            : const Center(
                                child:
                                    CircularProgressIndicator(strokeWidth: 2)),
                        errorBuilder: (_, __, ___) => const Center(
                            child: Icon(Icons.image_not_supported, size: 40)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  // Title
                  Text(
                    title,
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Rating and review count
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 16),
                      const SizedBox(width: 4),
                      Text(rating,
                          style: const TextStyle(
                              color: Colors.white, fontSize: 14)),
                      const Spacer(),
                      const Icon(Icons.people, color: Colors.grey, size: 16),
                      const SizedBox(width: 4),
                      Text(reviewCount,
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 14)),
                    ],
                  ),

                  // Review comment (if available)
                  if (reviewComment.isNotEmpty) ...[
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.comment, color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            reviewComment,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 6),

                  // Bottom row: info tags
                  Wrap(
                    spacing: 8,
                    children: [
                      _buildBadge(
                        icon: breakfastIncluded == "True"
                            ? Icons.restaurant
                            : Icons.no_meals,
                        label: breakfastIncluded == "True"
                            ? "Breakfast"
                            : "No Breakfast",
                        backgroundColor: breakfastIncluded == "True"
                            ? Colors.green[900]!
                            : Colors.red[900]!,
                      ),
                      _buildBadge(
                        label: price,
                        backgroundColor: Colors.blue[900]!,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ).animate().fade(duration: 250.ms).slideX(),
        ),
      ),
    );
  }

  Widget _buildBadge({
    IconData? icon,
    required String label,
    required Color backgroundColor,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
        decoration: BoxDecoration(
            color: backgroundColor, borderRadius: BorderRadius.circular(12)),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, color: Colors.white, size: 14),
              const SizedBox(width: 4),
            ],
            Flexible(
              child: Text(
                label,
                style: const TextStyle(color: Colors.white, fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      );
}

class BookingCardGrid extends StatelessWidget {
  final List<BookingCard> cards;

  const BookingCardGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      // Show ~1.2 cards at once to hint at scroll
      final cardWidth = constraints.maxWidth / 1.2;

      // Use ConstrainedBox instead of SizedBox with a height
      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: [
            for (int i = 0; i < cards.length; i++) ...[
              if (i > 0) const SizedBox(width: 12),
              SizedBox(
                width: cardWidth,
                child: cards[i],
              ),
            ],
          ],
        ),
      );
    });
  }
}

/// Example data generator for [BookingCard] widgets.
List<BookingCard> getBookingCards(dynamic response) {
  final List<Map<String, dynamic>> scrapedDataList = response;
  return scrapedDataList.map((data) => BookingCard.fromJson(data)).toList();
}
