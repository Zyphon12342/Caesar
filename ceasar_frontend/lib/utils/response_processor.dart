import 'package:flutter/material.dart';
import '../components/cards/flight_compare_card.dart';
import '../components/cards/airbnb_card.dart';

class ResponseProcessor {
  static void processResponse({
    required dynamic response,
    required Function(String) onText,
    required Function(List<Widget>) onCards,
  }) {
    if (response is Map && response.containsKey('error')) {
      onText(response['error']);
      return;
    }

    if (response is Map && response.containsKey('type')) {
      final type = response['type'].toString();
      final data = response['data'];

      switch (type) {
        case 'flightCompare':
          final cards = FlightCompareCard.createCards(data as List<dynamic>);
          onCards([FlightCompareCardGrid(cards: cards)]);
          break;
        case 'airbnb':
          //currently testing static data
          final cards = AirbnbCard.createCards(data as List<dynamic>);
          onCards([AirbnbCardGrid(cards: cards)]);
          break;
        default:
          onText(data?.toString() ?? 'Unknown response type');
      }
    } else {
      onText(response.toString());
    }
  }
}

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
