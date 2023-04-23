import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_gpt/constants/constants.dart';
import 'package:flutter_gpt/providers/open_ai_provider.dart';
import 'package:flutter_gpt/api/speech_text_recognizer.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:flutter_gpt/providers/text_to_speech_provider.dart';

class CustomTextField extends StatefulWidget {
  final OpenAIProvider openAIState;
  final TextEditingController textEditingController;

  const CustomTextField({
    super.key,
    required this.openAIState,
    required this.textEditingController,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool isListening = false;
  bool isTextFieldEmpty = true;

  _checkSpeechAvailability() async {
    await SpeechTextRecognizer.initialize();
  }

  _recognizedText() async {
    setState(() {
      isListening = true;
    });
    await SpeechTextRecognizer.startListning(speechRecogListner);
  }

  void speechRecogListner(SpeechRecognitionResult result) async {
    if (result.finalResult && result.recognizedWords.isNotEmpty) {
      await widget.openAIState.sendMessage(
        message: result.recognizedWords,
      );
      setState(() {
        isListening = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _checkSpeechAvailability();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<TextToSpeechProvider>(
      builder: (context, textToSpeechState, child) {
        return textToSpeechState.isPlaying
            ? const Padding(
                padding: EdgeInsets.all(20.0),
                child: SpinKitWave(
                  color: Colors.green,
                  size: 30.0,
                ),
              )
            : widget.openAIState.isThinking
                ? const Padding(
                    padding: EdgeInsets.all(15.0),
                    child: SpinKitThreeBounce(
                      color: primaryColor,
                      size: 25.0,
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(15.0),
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20.0,
                              ),
                              child: ConstrainedBox(
                                constraints: const BoxConstraints(
                                  maxHeight: 200.0,
                                ),
                                child: TextField(
                                  onChanged: (text) {
                                    if (text.isEmpty) {
                                      setState(() {
                                        isTextFieldEmpty = true;
                                      });
                                    } else {
                                      setState(() {
                                        isTextFieldEmpty = false;
                                      });
                                    }
                                  },
                                  maxLines: null,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintStyle: GoogleFonts.poppins(
                                      fontSize: 16.0,
                                      color: Colors.white70,
                                      fontWeight: FontWeight.w300,
                                    ),
                                    hintText: "Send a message...",
                                  ),
                                  cursorColor: Colors.white70,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w300,
                                  ),
                                  controller: widget.textEditingController,
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: isTextFieldEmpty
                                ? GestureDetector(
                                    onTap: () async {
                                      try {
                                        if (SpeechTextRecognizer
                                            .isListening()) {
                                          setState(() {
                                            isListening = false;
                                          });
                                          SpeechTextRecognizer.stopListning();
                                        } else {
                                          await _recognizedText();
                                        }
                                      } catch (e) {
                                        Logger().e('Error: $e');
                                      }
                                      Future.delayed(
                                        const Duration(seconds: 10),
                                        () {
                                          if (!SpeechTextRecognizer
                                              .isListening()) {
                                            setState(() {
                                              isListening = false;
                                            });
                                            SpeechTextRecognizer.stopListning();
                                          }
                                        },
                                      );
                                    },
                                    child: AvatarGlow(
                                      animate: isListening,
                                      endRadius: 20.0,
                                      glowColor: isListening
                                          ? Colors.green
                                          : Colors.white,
                                      child: Icon(
                                        Icons.mic,
                                        size: 30,
                                        color: isListening
                                            ? Colors.green
                                            : Colors.white,
                                      ),
                                    ),
                                  )
                                : GestureDetector(
                                    onTap: () {
                                      if (widget.textEditingController.value
                                          .text.isNotEmpty) {
                                        widget.openAIState.sendMessage(
                                          message: widget
                                              .textEditingController.value.text,
                                        );
                                      }
                                      setState(() {
                                        isTextFieldEmpty = true;
                                      });
                                      widget.textEditingController.clear();
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: const Icon(
                                      size: 30,
                                      Icons.send,
                                      color: Colors.white70,
                                    ),
                                  ),
                          ),
                        ],
                      ),
                    ),
                  );
      },
    );
  }
}
