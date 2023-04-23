import 'package:flutter/cupertino.dart';
import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechProvider extends ChangeNotifier {
  String? _speechText;
  String? get speechText => _speechText;
  void setSpeechToText(String? speechText) {
    _speechText = speechText;
    notifyListeners();
  }

  void clearSpeechToText() {
    _speechText = null;
    notifyListeners();
  }

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;
  void setIsPlaying(bool isPlaying) {
    _isPlaying = isPlaying;
  }

  final FlutterTts _flutterTts = FlutterTts();
  FlutterTts get flutterTts => _flutterTts;

  void textToSpeechPlay(String text, void Function() updateState) async {
    setIsPlaying(true);
    notifyListeners();
    await _flutterTts.speak(text);
    await _flutterTts.setPitch(1.0);
    await _flutterTts.setVolume(1.0);
    await _flutterTts.setSpeechRate(0.4);
    await _flutterTts.setLanguage("en-US");
    flutterTts.setCompletionHandler(() {
      updateState();
      setIsPlaying(false);
      notifyListeners();
    });
    notifyListeners();
  }

  void textToSpeechPause(bool isPlaying) async {
    await flutterTts.pause();
    setIsPlaying(isPlaying);
    notifyListeners();
  }
}
