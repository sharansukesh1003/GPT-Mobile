import 'package:flutter/material.dart';
import 'package:flutter_gpt/api/open_ai_api.dart';
import 'package:flutter_gpt/model/chat_model.dart';

class OpenAIProvider extends ChangeNotifier {
  final List<Chat> _chatMessages = [];
  List<Chat> get chatMessages => _chatMessages.reversed.toList();

  bool _isThinking = false;
  bool get isThinking => _isThinking;

  bool _isSpeaking = false;
  bool get isSpeaking => _isSpeaking;
  void setIsSpeaking(bool setIsSpeaking) {
    _isSpeaking = setIsSpeaking;
    notifyListeners();
  }

  Future<void> sendMessage({required String message}) async {
    _chatMessages.insert(0, Chat(sender: "USER", message: message));
    _isThinking = true;
    notifyListeners();
    String? responseMessage = await OpenAIAPI.sendMessage(message: message)
        .timeout(const Duration(seconds: 60), onTimeout: () {
      _isThinking = false;
      _chatMessages.insert(
          0,
          Chat(
              sender: "ERROR",
              message: "Oops! The server timed out, GPT took too long."));
      notifyListeners();
      return "timed-out";
    });
    if (responseMessage != null && responseMessage != "timed-out") {
      _isThinking = false;
      _chatMessages.insert(0, Chat(sender: "GPT", message: responseMessage));
      notifyListeners();
    } else if (responseMessage == null) {
      _isThinking = false;
      _chatMessages.insert(
        0,
        Chat(sender: "ERROR", message: "Invalid API Key, kindly update the it"),
      );
      notifyListeners();
    }
  }
}
