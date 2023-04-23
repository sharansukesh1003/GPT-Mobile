// ignore_for_file: must_be_immutable
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gpt/utils/snackbars.dart';
import 'package:flutter_gpt/constants/constants.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_gpt/providers/text_to_speech_provider.dart';

class ChatTile extends StatefulWidget {
  final String sender;
  final String message;
  bool isPlaying;

  ChatTile({
    Key? key,
    required this.sender,
    required this.message,
    required this.isPlaying,
  }) : super(key: key);

  @override
  State<ChatTile> createState() => _ChatTileState();
}

class _ChatTileState extends State<ChatTile>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Container(
      color: widget.sender == "USER" ? primaryColor : secondaryColor,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (widget.sender == "GPT")
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    "Play GPT response",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: Colors.white70,
                      fontSize: 14.0,
                    ),
                  ),
                  widget.isPlaying
                      ? Consumer<TextToSpeechProvider>(
                          builder: (context, textToSpeechState, child) {
                            return IconButton(
                              onPressed: () {
                                textToSpeechState.textToSpeechPause(false);
                                setState(() {
                                  widget.isPlaying = false;
                                });
                              },
                              icon: const Icon(
                                size: 30,
                                Icons.pause_circle,
                                color: Colors.white,
                              ),
                            );
                          },
                        )
                      : Consumer<TextToSpeechProvider>(
                          builder: (context, state, child) {
                            return IconButton(
                              onPressed: () {
                                if (state.isPlaying) {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(SnackBars.audioBeingPlayed);
                                  return;
                                }
                                state.textToSpeechPlay(widget.message, () {
                                  setState(() {
                                    widget.isPlaying = false;
                                  });
                                });
                                setState(() {
                                  widget.isPlaying = true;
                                });
                              },
                              icon: const Icon(
                                size: 30,
                                Icons.play_circle,
                                color: Colors.white,
                              ),
                            );
                          },
                        ),
                ],
              ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onLongPress: () {
                Clipboard.setData(ClipboardData(text: widget.message));
                ScaffoldMessenger.of(context)
                    .showSnackBar(SnackBars.copiedToClipBoard);
              },
              child: AnimatedTextKit(
                animatedTexts: [
                  TypewriterAnimatedText(
                    widget.message,
                    cursor: "",
                    textStyle: GoogleFonts.poppins(
                      fontWeight: widget.sender == "USER"
                          ? FontWeight.w500
                          : FontWeight.w300,
                      color: widget.sender == "ERROR"
                          ? Colors.red
                          : Colors.white70,
                      fontSize: 14.0,
                    ),
                    speed: const Duration(milliseconds: 50),
                  ),
                ],
                totalRepeatCount: 1,
                pause: const Duration(milliseconds: 50),
                displayFullTextOnTap: false,
                stopPauseOnTap: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
