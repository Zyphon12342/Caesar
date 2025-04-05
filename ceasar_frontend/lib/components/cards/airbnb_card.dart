import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class AirbnbCard extends StatelessWidget {
  final String imageUrl;
  final String paymentUrl;
  final String hotelName;
  final String location;
  final String ratingReviews;
  final String totalPrice;
  final String tagText;

  const AirbnbCard({
    super.key,
    required this.imageUrl,
    required this.paymentUrl,
    required this.hotelName,
    required this.location,
    required this.ratingReviews,
    required this.totalPrice,
    required this.tagText,
  });

  factory AirbnbCard.fromJson(Map<String, dynamic> json) {
    return AirbnbCard(
      imageUrl: json["image_url"] ?? "",
      paymentUrl: json["payment_url"] ?? "",
      hotelName: json["hotel_name"] ?? "Unknown",
      location: json["location"] ?? "Unknown",
      ratingReviews: json["rating_reviews"] ?? "0.0 (0)",
      totalPrice: json["total_price"] ?? "N/A",
      tagText: json["tag_text"] ?? "",
    );
  }

  /// Static method to create a list of AirbnbCards from a JSON list.
  static List<AirbnbCard> createCards(List<dynamic> data) {
    return data.map((item) => AirbnbCard.fromJson(item)).toList();
  }

  Future<void> _launchURL(BuildContext context) async {
    final Uri uri = Uri.parse(paymentUrl);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $paymentUrl");
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
            content: const Text("Proceed to Airbnb listing?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Back"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: const Text("Ok"),
              ),
            ],
          ),
        );
        if (confirmed == true) {
          _launchURL(context);
        }
      },
      child: SizedBox(
        width: 165,
        height: 260,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 3,
          child: Container(
            padding: const EdgeInsets.all(14),
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
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 85,
                    child: Image.network(
                      imageUrl,
                      fit: BoxFit.cover,
                      loadingBuilder: (ctx, child, progress) => progress == null
                          ? child
                          : const Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                              ),
                            ),
                      errorBuilder: (_, __, ___) => const Center(
                          child: Icon(Icons.image_not_supported, size: 40)),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  hotelName,
                  style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.location_on, size: 15, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        location,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 15),
                    const SizedBox(width: 4),
                    Text(
                      ratingReviews,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        totalPrice,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                if (tagText.isNotEmpty)
                  _buildBadge(
                    label: tagText,
                    backgroundColor: Colors.orange[900]!,
                  ),
              ],
            ),
          ),
        ).animate().fade(duration: 250.ms).slideX(),
      ),
    );
  }

  Widget _buildBadge({
    required String label,
    required Color backgroundColor,
  }) =>
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          label,
          style: const TextStyle(color: Colors.white, fontSize: 12),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      );
}

class AirbnbCardGrid extends StatelessWidget {
  final List<AirbnbCard> cards;

  const AirbnbCardGrid({super.key, required this.cards});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 280,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: cards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (context, index) => SizedBox(
          width: MediaQuery.of(context).size.width * 0.6875,
          child: cards[index],
        ),
      ),
    );
  }
}
