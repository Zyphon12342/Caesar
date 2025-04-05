// lib/card/restaurant.dart
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RestaurantCard extends StatelessWidget {
  final String name;
  final String number; // e.g. number of reviews
  final String rating;
  final String image_url;
  final String restaurant_url;
  final List<String> tags;

  const RestaurantCard({
    super.key,
    required this.name,
    required this.number,
    required this.rating,
    required this.image_url,
    required this.restaurant_url,
    required this.tags,
  });

  /// Creates an instance of [RestaurantCard] from a JSON object.
  factory RestaurantCard.fromJson(Map<String, dynamic> json) {
    return RestaurantCard(
      name: json["name"] ?? "",
      number: json["number_of_reviews"] ?? "",
      rating: json["star"] ?? "",
      image_url: json["image"] ?? "",
      restaurant_url: json["url"] ?? "",
      tags: (json["tags"] ?? "")
          .toString()
          .split(",")
          .map((e) => e.trim())
          .toList(),
    );
  }

  /// Creates a list of [RestaurantCard] widgets from a JSON list.
  static List<RestaurantCard> createCards(List<dynamic> data) {
    return data.map((item) => RestaurantCard.fromJson(item)).toList();
  }

  Future<void> _launchUrl(BuildContext context) async {
    final Uri uri = Uri.parse(restaurant_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $restaurant_url");
    }
  }

  @override
  Widget build(BuildContext context) {
    // Only display up to 3 tags.
    final List<String> displayedTags =
        tags.length > 3 ? tags.sublist(0, 3) : tags;

    return GestureDetector(
      onTap: () async {
        final confirmed = await showDialog<bool>(
          context: context,
          builder: (_) => AlertDialog(
            title: const Text("Confirmation"),
            content:
                const Text("Do you want to proceed to the restaurant listing?"),
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
          _launchUrl(context);
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
                // Image section
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: SizedBox(
                    width: double.infinity,
                    height: 85,
                    child: Image.network(
                      image_url,
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
                // Restaurant name
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                // Reviews row
                Row(
                  children: [
                    const Icon(Icons.people, size: 15, color: Colors.grey),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        '$number reviews',
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
                // Rating row
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 15),
                    const SizedBox(width: 4),
                    Text(
                      rating,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Display all 3 green info tags
                Wrap(
                  spacing: 6.0,
                  runSpacing: 6.0,
                  children: displayedTags.map((tag) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: Colors.green[900],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        tag,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ).animate().fade(duration: 250.ms).slideX(),
      ),
    );
  }
}

class RestaurantCardGrid extends StatelessWidget {
  final List<RestaurantCard> cards;

  const RestaurantCardGrid({super.key, required this.cards});

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

/// Example data generator for [RestaurantCard] widgets.
List<RestaurantCard> getRestaurantCards(List<Map<String, dynamic>> response) {
  final List<Map<String, dynamic>> restaurantDataList = response;
  return restaurantDataList
      .map((data) => RestaurantCard.fromJson(data))
      .toList();
}
