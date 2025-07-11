import 'dart:convert';
import 'package:http/http.dart' as http;

class ChatService {
  static const apiKey = "";
  static const endpoint = "https://api.openai.com/v1/chat/completions";

  static Future<String> getChatReply(String message) async {
    try {
      final response = await http.post(
        Uri.parse(endpoint),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {"role": "user", "content": message}
          ],
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "❌ Error: ${response.statusCode}";
      }
    } catch (e) {
      return "⚠️ Failed: $e";
    }
  }
}
