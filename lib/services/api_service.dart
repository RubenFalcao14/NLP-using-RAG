import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  static Future<String> askQuestion(String question) async {
    final url = Uri.parse('http://127.0.0.1:5000/ask');
    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: json.encode({"question": question}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['answer'].toString();
      } else {
        return 'Error: ${response.statusCode} - ${response.reasonPhrase}';
      }
    } catch (e) {
      return 'Failed to connect: $e';
    }
  }
}
