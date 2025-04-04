import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_animate/flutter_animate.dart';

class FlightCompareCard extends StatelessWidget {
  final String airline;
  final String airlineLogo;
  final String departureTime;
  final String departureCity;
  final String arrivalTime;
  final String arrivalCity;
  final String duration;
  final String price;
  final String fareType;
  final String layover;
  final String url;
  final String? provider1Name;
  final String? provider1Price;
  final String? provider1Url;
  final String? provider2Name;
  final String? provider2Price;
  final String? provider2Url;

  const FlightCompareCard({
    super.key,
    required this.airline,
    required this.airlineLogo,
    required this.departureTime,
    required this.departureCity,
    required this.arrivalTime,
    required this.arrivalCity,
    required this.duration,
    required this.price,
    required this.fareType,
    required this.layover,
    required this.url,
    this.provider1Name,
    this.provider1Price,
    this.provider1Url,
    this.provider2Name,
    this.provider2Price,
    this.provider2Url,
  });

  Future<void> _launchUrl(String url) async {
    if (url.isEmpty) return;
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  Widget _buildProviderPrice(String name, String price, String url) {
    return GestureDetector(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[700]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    color: Colors.grey[400],
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  price,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.open_in_new, size: 16, color: Colors.blue),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[850],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: const EdgeInsets.all(4),
                  child: Image.network(
                    airlineLogo,
                    width: 40,
                    height: 40,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.airplanemode_active, size: 40),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        airline,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        fareType,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        departureCity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        departureTime,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.flight_takeoff, color: Colors.white, size: 28),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        arrivalCity,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        arrivalTime,
                        style: TextStyle(color: Colors.grey[400], fontSize: 14),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(duration, style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: layover.toLowerCase() == "direct"
                        ? Colors.green[800]
                        : Colors.orange[800],
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    layover.toLowerCase() == "direct" ? "Non-stop" : "Layover",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => _launchUrl(url),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[900],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          "Cheapflights",
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              price,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.arrow_forward,
                              size: 16,
                              color: Colors.white,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                if (provider1Name != null && provider1Price != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: _buildProviderPrice(
                      provider1Name!,
                      provider1Price!,
                      provider1Url ?? "",
                    ),
                  ),
                if (provider2Name != null && provider2Price != null)
                  _buildProviderPrice(
                    provider2Name!,
                    provider2Price!,
                    provider2Url ?? "",
                  ),
              ],
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 300.ms).slideX();
  }
}

List<FlightCompareCard> getFlightCompareCards(
  List<Map<String, dynamic>> response,
) {
  return response.map((flight) {
    return FlightCompareCard(
      airline: flight["airline"] ?? "Unknown Airline",
      airlineLogo: flight["airline_logo"] ?? "",
      departureTime: flight["departure_time"] ?? "--:--",
      departureCity: flight["departure_city"] ?? "",
      arrivalTime: flight["arrival_time"] ?? "--:--",
      arrivalCity: flight["arrival_city"] ?? "",
      duration: flight["duration"] ?? "",
      price: flight["price"] ?? "₹—",
      fareType: flight["fare_type"] ?? "Economy",
      layover: flight["layover"] ?? "direct",
      url: flight["url"] ?? "",
      provider1Name: flight["provider1_name"]?.toString(),
      provider1Price: flight["provider1_price"]?.toString(),
      provider1Url: flight["provider1_url"]?.toString(),
      provider2Name: flight["provider2_name"]?.toString(),
      provider2Price: flight["provider2_price"]?.toString(),
      provider2Url: flight["provider2_url"]?.toString(),
    );
  }).toList();
}

final Map<String, dynamic> staticFlightData = {
  'type': 'flightCompare',
  'data': [
    {
      'provider': 'Cheapflights',
      'airline': 'Akasa Air',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/QP.png?crop=false&width=108&height=92&fallback=default3.png&v=28417c5db929f1c9cb82aff5afaf0e18',
      'departure_time': '03:25',
      'departure_city': 'Bangalore',
      'arrival_time': '05:15',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 3,641',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.xhWnyDcgiRcDzQq2dWkU9A.4262.6642ff5ffe023bd537a883d5fa42f55f&h=72075d171350&sub=F-927935095398472859E0081945c941&payment=0.00:INR:BT:BankTransfer:true&bucket=e&pageOrigin=F..RP.FE.M1',
      'provider1_name': 'HolidayBreakz',
      'provider1_price': '₹ 4,170',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.30MnxG5LI9d6vGlYpbXIDw.4881.6642ff5ffe023bd537a883d5fa42f55f&h=8c2f4b6dd84f&sub=F-7836406035201911170E099082d2be8&payment=0.00:INR:BT:BankTransfer:true&bucket=e&pageOrigin=F..RP.MB.M1',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,464',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5224.6642ff5ffe023bd537a883d5fa42f55f&h=e7b3b38e4f7b&sub=F6052819343990841860E08da80eefa5&payment=0.00:INR:BT:BankTransfer:true&bucket=e&pageOrigin=F..RP.MB.M1'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '14:00',
      'departure_city': 'Bangalore',
      'arrival_time': '15:45',
      'arrival_city': 'Mumbai',
      'duration': '1h 45m',
      'price': '₹ 4,593',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5377.06a002fc75e51229649a344378bbe420&h=a8998461badb&sub=F1970668837668402546E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M2',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 4,613',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5400.06a002fc75e51229649a344378bbe420&h=e914704e3cb6&sub=F-927935095063003205E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M2',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,646',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5437.06a002fc75e51229649a344378bbe420&h=8ec6058e6ca5&sub=F6052819341925069833E0b7031ca4eb&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M2'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '15:25',
      'departure_city': 'Bangalore',
      'arrival_time': '17:15',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 4,593',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5377.a4f003e4038ce93751668e3072cc0fbd&h=1919cc207652&sub=F1970668835862868555E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M3',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 4,613',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5400.a4f003e4038ce93751668e3072cc0fbd&h=63b199183182&sub=F-927935095288823325E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M3',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,646',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5437.a4f003e4038ce93751668e3072cc0fbd&h=ffdb975e730d&sub=F6052819344822207179E0b7031ca4eb&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M3'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '10:10',
      'departure_city': 'Bangalore',
      'arrival_time': '12:00',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 4,593',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5377.a30ce71b2211dace97ee5a2648a88ffa&h=e3ff086aa11d&sub=F1970668835016493039E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M5',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 4,613',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5400.a30ce71b2211dace97ee5a2648a88ffa&h=e472974ae4e8&sub=F-927935094753331815E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M5',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,646',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5437.a30ce71b2211dace97ee5a2648a88ffa&h=57bb7935ceb4&sub=F6052819344589957026E0b7031ca4eb&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M5'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '03:30',
      'departure_city': 'Bangalore',
      'arrival_time': '05:20',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 4,593',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5377.1830acd8a0080f47fdda9d6423beb75f&h=10eec25085a9&sub=F1970668834353666066E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M8',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 4,613',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5400.1830acd8a0080f47fdda9d6423beb75f&h=f81c2b36c985&sub=F-927935093862582215E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M8',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,646',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5437.1830acd8a0080f47fdda9d6423beb75f&h=2c4d61fbfd11&sub=F6052819341170791883E0b7031ca4eb&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M8'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '12:40',
      'departure_city': 'Bangalore',
      'arrival_time': '14:30',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 4,593',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5377.fc97c02a0fba6a82390f4cdaecb31901&h=62854780e82d&sub=F1970668835599407918E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M9',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 4,613',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5400.fc97c02a0fba6a82390f4cdaecb31901&h=b8053bbe0ae3&sub=F-927935097091639265E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M9',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,646',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5437.fc97c02a0fba6a82390f4cdaecb31901&h=cf05a43170f0&sub=F6052819344899234772E0b7031ca4eb&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M9'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '23:30',
      'departure_city': 'Bangalore',
      'arrival_time': '01:20\n+1',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 4,593',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5377.e41fe9cb8d3fa49a83f9a1aa124a6939&h=79cd89fb25c5&sub=F1970668835245737906E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M10',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 4,613',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5400.e41fe9cb8d3fa49a83f9a1aa124a6939&h=b70bf0942a02&sub=F-927935095543258292E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M10',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,646',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5437.e41fe9cb8d3fa49a83f9a1aa124a6939&h=7fc81bfe05eb&sub=F6052819340658500730E0b7031ca4eb&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M10'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '11:25',
      'departure_city': 'Bangalore',
      'arrival_time': '13:15',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 4,593',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5377.c3ecfcc9a67a706f813819b2f1e314b5&h=ec12701725a5&sub=F1970668837614203211E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M11',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 4,613',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5400.c3ecfcc9a67a706f813819b2f1e314b5&h=20e694448345&sub=F-927935095375242457E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M11',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,646',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5437.c3ecfcc9a67a706f813819b2f1e314b5&h=6b75c915926d&sub=F6052819341216708527E0b7031ca4eb&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M11'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '04:55',
      'departure_city': 'Bangalore',
      'arrival_time': '06:50',
      'arrival_city': 'Mumbai',
      'duration': '1h 55m',
      'price': '₹ 4,593',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5377.76136a60b7fa5ee60d52b7b2d45df800&h=35d8d0ba7aab&sub=F1970668833926648214E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M13',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 4,613',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5400.76136a60b7fa5ee60d52b7b2d45df800&h=4d42abe52e41&sub=F-927935095699268169E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M13',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,646',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5437.76136a60b7fa5ee60d52b7b2d45df800&h=e82d39b354b0&sub=F6052819344698097588E0b7031ca4eb&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M13'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'Air India',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/AI.png?crop=false&width=108&height=92&fallback=default1.png&v=18d6ba2bd1a6b89120361f37345483d6',
      'departure_time': '10:30',
      'departure_city': 'Bangalore',
      'arrival_time': '12:35',
      'arrival_city': 'Mumbai',
      'duration': '2h 05m',
      'price': '₹ 4,733',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.Ucg_mpDvUUAEdn9PX-8xhQ.5540.ceec858db662bdce105f2814915267c7&h=6465220d44fd&sub=F6397298292718325794E061998969c8&payment=0.00:INR:VA:Visa:true&bucket=e&pageOrigin=F..RP.FE.M14',
      'provider1_name': 'BudgetAir',
      'provider1_price': '₹ 4,744',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.tYUOhBwwtNbTYwQ_VUUUMA.5553.ceec858db662bdce105f2814915267c7&h=a0d119e14599&sub=F1970668836419495023E0f367ab3158&payment=0.00:INR:VA:Visa:true&bucket=e&pageOrigin=F..RP.MB.M14',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,820',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5641.ceec858db662bdce105f2814915267c7&h=fb9b2adb4bbf&sub=F6052819344762953378E071332c8ed7&payment=0.00:INR:BT:BankTransfer:true&bucket=e&pageOrigin=F..RP.MB.M14'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'Air India',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/AI.png?crop=false&width=108&height=92&fallback=default1.png&v=18d6ba2bd1a6b89120361f37345483d6',
      'departure_time': '13:45',
      'departure_city': 'Bangalore',
      'arrival_time': '15:50',
      'arrival_city': 'Mumbai',
      'duration': '2h 05m',
      'price': '₹ 4,753',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.uzHPU4hZqELIhcCCciqklw.5563.f98db40f5233bb66b28c6ad1a5de9b72&h=4425620cd5ec&sub=F6052819341195469689E0c38ea90bc3&payment=0.00:INR:BT:BankTransfer:true&bucket=e&pageOrigin=F..RP.FE.M15',
      'provider1_name': 'Vakatrip',
      'provider1_price': '₹ 4,840',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.Ucg_mpDvUUAEdn9PX-8xhQ.5666.f98db40f5233bb66b28c6ad1a5de9b72&h=c73a5060b0b7&sub=F6397298295213061621E061998969c8&payment=0.00:INR:VA:Visa:true&bucket=e&pageOrigin=F..RP.MB.M15',
      'provider2_name': 'BudgetAir',
      'provider2_price': '₹ 4,848',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.tYUOhBwwtNbTYwQ_VUUUMA.5675.f98db40f5233bb66b28c6ad1a5de9b72&h=166b8cb9ab4e&sub=F1970668837235213873E0f367ab3158&payment=0.00:INR:VA:Visa:true&bucket=e&pageOrigin=F..RP.MB.M15'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'Air India',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/AI.png?crop=false&width=108&height=92&fallback=default1.png&v=18d6ba2bd1a6b89120361f37345483d6',
      'departure_time': '09:10',
      'departure_city': 'Bangalore',
      'arrival_time': '11:10',
      'arrival_city': 'Mumbai',
      'duration': '2h 00m',
      'price': '₹ 4,840',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.Ucg_mpDvUUAEdn9PX-8xhQ.5666.581359fb224515f5bf1a53f5027e5af5&h=f3cb83b17607&sub=F6397298296013007025E061998969c8&payment=0.00:INR:VA:Visa:true&bucket=e&pageOrigin=F..RP.FE.M16',
      'provider1_name': 'BudgetAir',
      'provider1_price': '₹ 4,848',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.tYUOhBwwtNbTYwQ_VUUUMA.5675.581359fb224515f5bf1a53f5027e5af5&h=e44c02e6d855&sub=F1970668836796266277E0f367ab3158&payment=0.00:INR:VA:Visa:true&bucket=e&pageOrigin=F..RP.MB.M16',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 4,897',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.5731.581359fb224515f5bf1a53f5027e5af5&h=17524a000c1e&sub=F6052819341758717096E071332c8ed7&payment=0.00:INR:BT:BankTransfer:true&bucket=e&pageOrigin=F..RP.MB.M16'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'Air India',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/AI.png?crop=false&width=108&height=92&fallback=default1.png&v=18d6ba2bd1a6b89120361f37345483d6',
      'departure_time': '22:45',
      'departure_city': 'Bangalore',
      'arrival_time': '00:50\n+1',
      'arrival_city': 'Mumbai',
      'duration': '2h 05m',
      'price': '₹ 4,891',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.30MnxG5LI9d6vGlYpbXIDw.5725.3400a4b268998ed5325db215aee8be16&h=10dcc49c2e20&sub=F-7836406036468603907E099082d2be8&payment=0.00:INR:BT:BankTransfer:true&bucket=e&pageOrigin=F..RP.FE.M18',
      'provider1_name': 'EaseMyTrip',
      'provider1_price': '₹ 5,495',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.6431.3400a4b268998ed5325db215aee8be16&h=121988c9f24d&sub=F6052819342747385898E0c5c5f32ed2&payment=0.00:INR:BT:BankTransfer:true&bucket=e&pageOrigin=F..RP.MB.M18',
      'provider2_name': 'BudgetAir',
      'provider2_price': '₹ 5,523',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.tYUOhBwwtNbTYwQ_VUUUMA.6465.3400a4b268998ed5325db215aee8be16&h=61273f8b3685&sub=F1970668837584412295E0f367ab3158&payment=0.00:INR:VA:Visa:true&bucket=e&pageOrigin=F..RP.MB.M18'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '22:30',
      'departure_city': 'Bangalore',
      'arrival_time': '00:20\n+1',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 5,027',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.5885.85a8d352601b2079d8bb7484aec58f4e&h=caab970fd5fb&sub=F1970668834849937862E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M19',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 5,112',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.5984.85a8d352601b2079d8bb7484aec58f4e&h=edde43109e2e&sub=F-927935093805000616E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M19',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 5,145',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.6022.85a8d352601b2079d8bb7484aec58f4e&h=e8b6bc8ecea9&sub=F6052819341811429855E0aa39b81a1f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M19'
    },
    {
      'provider': 'Cheapflights',
      'airline': 'IndiGo',
      'airline_logo':
          'https://content.r9cdn.net/rimg/provider-logos/airlines/v/6E.png?crop=false&width=108&height=92&fallback=default1.png&v=9d74e28098b1f027dfed38964910a11a',
      'departure_time': '08:50',
      'departure_city': 'Bangalore',
      'arrival_time': '10:40',
      'arrival_city': 'Mumbai',
      'duration': '1h 50m',
      'price': '₹ 5,381',
      'fare_type': 'Economy',
      'offer': '',
      'layover': 'direct',
      'url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt.tYUOhBwwtNbTYwQ_VUUUMA.6299.79b2c59156da355956eaabb733fd1a2a&h=cc1a75b26c46&sub=F1970668835649416930E09e3c4768ea&payment=0.00:INR:VA:Visa:true&bucket=ECONOMY&pageOrigin=F..RP.FE.M20',
      'provider1_name': 'Yatra.com',
      'provider1_price': '₹ 5,525',
      'provider1_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.xhWnyDcgiRcDzQq2dWkU9A.6467.79b2c59156da355956eaabb733fd1a2a&h=aba2f631aed0&sub=F-927935096768871076E05bba96968f&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M20',
      'provider2_name': 'EaseMyTrip',
      'provider2_price': '₹ 5,558',
      'provider2_url':
          'https://www.in.cheapflights.com/book/flight?code=hXGiFztxt_.uzHPU4hZqELIhcCCciqklw.6505.79b2c59156da355956eaabb733fd1a2a&h=89ca9b89533c&sub=F6052819344674994223E054147a3d29&payment=0.00:INR:BT:BankTransfer:true&bucket=ECONOMY&pageOrigin=F..RP.MB.M20'
    }
  ]
};
