import 'package:logger/logger.dart';
import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:flutter_gpt/utils/cache_service.dart';

class OpenAIAPI {
  static late final OpenAI? openAI;

  static Future<void> init() async {
    try {
      String? key = await CacheService.getOpenAIAPIKey(key: "apiKey");
      if (key != null) {
        openAI = OpenAI.instance.build(
          token: key,
          baseOption: HttpSetup(
            receiveTimeout: const Duration(seconds: 60),
          ),
        );
      }
    } catch (error) {
      Logger().e(error);
    }
  }

  static Future<bool> verifyOpenAIAPIKey({required String apiKey}) async {
    try {
      openAI = OpenAI.instance.build(
        token: apiKey,
        baseOption: HttpSetup(
          receiveTimeout: const Duration(seconds: 60),
        ),
      );
      await CacheService.setOpenAIAPIKey(apiKey: apiKey);
      return true;
    } catch (error) {
      if (error.toString() ==
          "LateInitializationError: Field 'openAI' has already been initialized.") {
        return true;
      }
      Logger().e(error.toString());
      return false;
    }
  }

  static Future<String?> sendMessage({required String message}) async {
    try {
      final request = ChatCompleteText(messages: [
        Map.of({"role": "user", "content": message})
      ], model: ChatModel.gptTurbo0301, maxToken: 1000);
      final response = await openAI!.onChatCompletion(
        request: request,
      );
      Logger().i(response!.choices[0].message!.content);
      return response.choices[0].message!.content;
    } catch (error) {
      Logger().e(error);
      return null;
    }
  }
}
