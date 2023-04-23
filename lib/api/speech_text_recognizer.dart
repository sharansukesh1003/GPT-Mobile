import 'package:logger/logger.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:speech_to_text/speech_recognition_result.dart';

class SpeechTextRecognizer {
  static SpeechToText speechToText = SpeechToText();

  static initialize() async {
    try {
      bool status = await speechToText.initialize();
      return status;
    } catch (error) {
      Logger().e(error);
    }
  }

  static startListning(
      Function(SpeechRecognitionResult) recognitionCallBack) async {
    try {
      await speechToText.listen(
        onResult: recognitionCallBack,
        listenMode: ListenMode.dictation,
        listenFor: const Duration(seconds: 30),
      );
    } catch (e) {
      Logger().e(e);
    }
  }

  static void stopListning() async {
    await speechToText.stop();
  }

  static bool isListening() {
    return speechToText.isListening;
  }
}
