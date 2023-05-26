import 'dart:math';
import 'package:http/http.dart' as http;

class TelegramClient {
  final String chatId;
  final String botToken = "5380316718:AAFJTrMDURRy8T8iDTLSNqjw6FXPpsmN9TQ";
  TelegramClient({
    this.chatId,
  });

  // Text of the message to be sent, 1-4096 characters after entities parsing
  // https://core.telegram.org/bots/api#sendmessage
  String _limitMessage(final String message) =>
      message.substring(0, min(4096, message.length));

  Future<http.Response> sendMessage(final String message) async {
    final Uri uri = Uri.https(
      "api.telegram.org",
      "/bot$botToken/sendMessage",
      {
        "chat_id": chatId,
        "text": _limitMessage(message),
        "parse_mode": "html",
      },
    );
    http.Response r = await http.get(uri);
    return r;
  }
}