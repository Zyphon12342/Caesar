import 'package:flutter/material.dart';
import '../components/cards/flight_compare_card.dart';
import '../components/cards/airbnb_card.dart';
import '../components/cards/restaurant.dart';
import '../components/cards/bus_card.dart';
import '../components/cards/booking_dot_com_card.dart';
import '../components/cards/booking_dot_com_card.dart' show BookingCardGrid;

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
          final cards = AirbnbCard.createCards(data as List<dynamic>);
          onCards([AirbnbCardGrid(cards: cards)]);
          break;
        case 'restaurant':
          final cards = RestaurantCard.createCards(data as List<dynamic>);
          onCards([RestaurantCardGrid(cards: cards)]);
          break;
        case 'bus':
          final cards = BusCard.createCards(data as List<dynamic>);
          onCards([BusCardGrid(cards: cards)]);
          break;
        case 'booking':
          final cards = BookingCard.createCards(data as List<dynamic>);
          onCards([BookingCardGrid(cards: cards)]);
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
