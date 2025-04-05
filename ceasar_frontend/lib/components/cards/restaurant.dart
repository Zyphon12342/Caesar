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

  Future<void> _launchUrl() async {
    final Uri uri = Uri.parse(restaurant_url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch $restaurant_url");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> displayedTags =
        tags.length > 3 ? tags.sublist(0, 3) : tags;

    return GestureDetector(
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text(
                  "Do you want to proceed to the restaurant listing?"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text("Back"),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
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
        width: MediaQuery.of(context).size.width * 0.75,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Colors.black, Color(0xFF23272A)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius:
                          const BorderRadius.vertical(top: Radius.circular(16)),
                      child: Image.network(
                        image_url,
                        height: 220,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const Center(
                              child: CircularProgressIndicator());
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              rating,
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
                        name,
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.people,
                              size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '$number reviews',
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8.0,
                        runSpacing: 8.0,
                        children: displayedTags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green[900],
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              tag,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
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

class RestaurantCardGrid extends StatelessWidget {
  final List<RestaurantCard> cards;

  const RestaurantCardGrid({super.key, required this.cards});

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

/// Example data generator for [RestaurantCard] widgets.
List<RestaurantCard> getRestaurantCards(List<Map<String, dynamic>> response) {
  final List<Map<String, dynamic>> restaurantDataList = response;
  return restaurantDataList
      .map((data) => RestaurantCard.fromJson(data))
      .toList();
}
