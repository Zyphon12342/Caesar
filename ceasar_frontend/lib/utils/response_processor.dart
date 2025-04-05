import 'package:flutter/material.dart';
import '../components/cards/flight_compare_card.dart';
import '../components/cards/airbnb_card.dart';
import '../components/cards/restaurant.dart';
import '../components/cards/bus_card.dart';
import '../components/cards/booking_dot_com_card.dart';
import '../components/cards/booking_dot_com_card.dart' show BookingCardGrid;
import '../components/cards/train_compare_card.dart';

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
    if (response == null || response.isEmpty) {
      onText('No response received.');
      return;
    }
    if (response is Map && response.containsKey('type')) {
      debugPrint('Response type: ${response['type']}');
      debugPrint('Response data: ${response['data']}');
      final type = response['type'].toString();
      final data = response['data'];
      if (data == null || data.isEmpty) {
        onText('No data received.');
        return;
      }

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
        case 'trainCompare':
          final cards = TrainCompareCard.createCards(data as List<dynamic>);
          onCards([TrainCompareCardGrid(cards: cards)]);
          break;
        default:
          onText(data?.toString() ?? 'Unknown response type');
      }
    } else {
      onText(response.toString());
    }
  }
}
