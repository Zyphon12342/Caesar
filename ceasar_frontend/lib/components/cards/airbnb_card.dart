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
      imageUrl: json["image_url"] ?? "", // Default to empty string
      paymentUrl: json["payment_url"] ?? "",
      hotelName: json["hotel_name"] ?? "Unknown", // Fallback value
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
      onTap: () {
        showDialog<bool>(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text("Confirmation"),
              content: const Text("Do you want to proceed to the Airbnb listing?"),
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
            _launchURL(context);
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
                        imageUrl,
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
                      left: 12,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.7),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          tagText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
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
                        hotelName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.location_on, size: 16, color: Colors.grey),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              location,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: Colors.amber, size: 20),
                              const SizedBox(width: 4),
                              Text(
                                ratingReviews,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: Colors.blue[900],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              totalPrice,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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

List<AirbnbCard> getAirbnbCards(dynamic response) {
  final List<Map<String, dynamic>> airbnbDataList = response;

  return airbnbDataList.map((response) {
    return AirbnbCard(
      imageUrl: response["image_url"] ?? "", // Default to empty string
      paymentUrl: response["payment_url"] ?? "",
      hotelName: response["hotel_name"] ?? "Unknown", // Fallback value
      location: response["location"] ?? "Unknown",
      ratingReviews: response["rating_reviews"] ?? "0.0 (0)",
      totalPrice: response["total_price"] ?? "N/A",
      tagText: response["tag_text"] ?? "",
    );
  }).toList();
}

class AirbnbCardGrid extends StatelessWidget {
  final List<AirbnbCard> cards;

  const AirbnbCardGrid({super.key, required this.cards});

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

Map<String, dynamic> staticAirnbnbData = {
  'type': 'airbnb',
  'data': [
    [
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/hosting/Hosting-1204266833177849093/original/41c6d4b6-1a37-4eed-b4be-38d19dc2e338.jpeg?im_w=720",
        "hotel_name": "Apartment in Pune",
        "payment_url":
            "https://www.airbnb.co.in/rooms/1204266833177849093?adults=2&check_in=2025-04-14&check_out=2025-04-15&search_mode=regular_search&source_impression_id=p3_1743795357_P3rzJTTUF5ujpE0o&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.86 (36)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/miso/Hosting-1166641853711758251/original/e989d39a-6f8f-41c9-ba17-087f5f05a93c.jpeg?im_w=720",
        "hotel_name": "Flat in Gahunje",
        "payment_url":
            "https://www.airbnb.co.in/rooms/1166641853711758251?adults=2&check_in=2025-04-14&check_out=2025-04-15&search_mode=regular_search&source_impression_id=p3_1743795358_P3xh9-cyWcIf83tb&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.93 (96)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/hosting/Hosting-1224410543433409007/original/94081bd8-c23b-4325-892e-ef55f2f618dc.jpeg?im_w=720",
        "hotel_name": "Apartment in Pune",
        "payment_url":
            "https://www.airbnb.co.in/rooms/1224410543433409007?adults=2&check_in=2025-04-14&check_out=2025-04-15&search_mode=regular_search&source_impression_id=p3_1743795358_P3VlbEtmaufLcsW1&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "5.0 (32)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/hosting/Hosting-1249051397972189086/original/1edc5587-bdcc-4f24-a167-9eab871e8f64.jpeg?im_w=720",
        "hotel_name": "Flat in Pune",
        "payment_url":
            "https://www.airbnb.co.in/rooms/1249051397972189086?adults=2&check_in=2025-04-14&check_out=2025-04-15&search_mode=regular_search&source_impression_id=p3_1743795358_P3_sblYMJi7-3FUm&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.96 (27)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/miso/Hosting-4639819/original/6be9bf79-089f-418b-940f-38173c6bcdb4.jpeg?im_w=720",
        "hotel_name": "Place to stay in Pune",
        "payment_url":
            "https://www.airbnb.co.in/rooms/4639819?adults=2&check_in=2025-04-14&check_out=2025-04-15&search_mode=regular_search&source_impression_id=p3_1743795358_P3AfkBhJpaYywtIm&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.73 (354)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/miso/Hosting-1304133153781349855/original/9edbaa6e-1762-4f62-a131-aeabfbad1623.jpeg?im_w=720",
        "hotel_name": "Flat in Pune",
        "payment_url":
            "https://www.airbnb.co.in/rooms/1304133153781349855?adults=2&check_in=2025-04-14&check_out=2025-04-15&search_mode=regular_search&source_impression_id=p3_1743795358_P3xdQSVI9VXqn42I&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.81 (26)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/hosting/Hosting-U3RheVN1cHBseUxpc3Rpbmc6OTI5NTg3NTEzOTc4NTc0ODk3/original/14252c04-9567-42a9-835a-770ab484d01b.jpeg?im_w=720",
        "hotel_name": "Flat in Gahunje",
        "payment_url":
            "https://www.airbnb.co.in/rooms/929587513978574897?adults=2&check_in=2025-04-14&check_out=2025-04-15&search_mode=regular_search&source_impression_id=p3_1743795358_P36LmsOTX5qMmSIT&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.84 (51)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/hosting/Hosting-U3RheVN1cHBseUxpc3Rpbmc6MzY2ODMxMTY%3D/original/7f73b2ba-87af-4ae6-b1b0-dc5260a03e5b.jpeg?im_w=720",
        "hotel_name": "Apartment in Pune",
        "payment_url":
            "https://www.airbnb.co.in/rooms/36683116?adults=2&check_in=2025-04-14&check_out=2025-04-15&search_mode=regular_search&source_impression_id=p3_1743795358_P3pCGRD9u0O0LPNH&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.97 (206)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/pictures/hosting/Hosting-U3RheVN1cHBseUxpc3Rpbmc6MTA3NTMxNzkzMDYwNzcwMzM1MQ%3D%3D/original/099b34f1-cb71-4730-ab75-3acbd98a7370.jpeg?im_w=720",
        "hotel_name": "Shipping container in Pune",
        "payment_url":
            "https://www.airbnb.co.in/rooms/1080156365379730837?adults=2&check_in=2025-04-15&check_out=2025-04-16&search_mode=regular_search&children=0&infants=0&pets=0&source_impression_id=p3_1743795359_P3-qANZfOXqUSCIg&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.97 (91)",
        "tag_text": "Guest favourite"
      },
      {
        "image_url":
            "https://a0.muscache.com/im/users/32428980/profile_pic/1435593994/original.jpg?im_w=720",
        "hotel_name": "Room in Pune",
        "payment_url":
            "https://www.airbnb.co.in/rooms/7065652?adults=2&check_in=2025-04-13&check_out=2025-04-15&search_mode=regular_search&category_tag=Tag%3A8678&children=0&infants=0&pets=0&photo_id=1071176143&source_impression_id=p3_1743795359_P3s_bqsNdRwsfVRV&previous_page_section_name=1000&federated_search_id=7182a22e-06bc-4891-a6dc-c392f8a9a391",
        "location": "Sam's BNB",
        "total_price": "\u20b93,081 for 1 night",
        "rating_reviews": "4.85 (241)",
        "tag_text": "Guest favourite"
      }
    ]
  ]
};
