import 'api/open_ai_api.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gpt/utils/cache_service.dart';
import 'package:flutter_gpt/screens/chat_screen.dart';
import 'package:flutter_gpt/providers/open_ai_provider.dart';
import 'package:flutter_gpt/screens/introduction_screen.dart';
import 'package:flutter_gpt/providers/text_to_speech_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? _apiKey;

  Future<void> _initializeChatScreenRoute() async {
    final String? fetchedKey =
        await CacheService.getOpenAIAPIKey(key: "apiKey");
    setState(() {
      _apiKey = fetchedKey;
    });
  }

  @override
  void initState() {
    super.initState();
    OpenAIAPI.init();
    _initializeChatScreenRoute();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<OpenAIProvider>(
          create: (_) => OpenAIProvider(),
        ),
        ChangeNotifierProvider<TextToSpeechProvider>(
          create: (_) => TextToSpeechProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter GPT',
        debugShowCheckedModeBanner: false,
        home: _apiKey != null
            ? const ChatScreen()
            : const CustomIntroductionScreen(),
      ),
    );
  }
}
