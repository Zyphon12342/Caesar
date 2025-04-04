import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const String _baseUrl = 'https://factual-maximum-newt.ngrok-free.app/';
  final Duration _timeout = const Duration(seconds: 60);
  http.Client? _client;

  Future<dynamic> sendMessage(String message, List<Map<String, dynamic>> history) async {
    _client?.close();
    _client = http.Client();

    try {
      final response = await _client!
          .post(
            Uri.parse(_baseUrl),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'message': message,
              'history': history,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode == 200) {
        return jsonDecode(utf8.decode(response.bodyBytes));
      }
      return {'error': 'Server responded with ${response.statusCode}'};
    } catch (e) {
      return {'error': e.toString()};
    } finally {
      _client?.close();
      _client = null;
    }
  }

  void cancelRequest() {
    _client?.close();
    _client = null;
  }
}