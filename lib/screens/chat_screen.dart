import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gpt/constants/constants.dart';
import 'package:flutter_gpt/widgets/chat_tile_widget.dart';
import 'package:flutter_gpt/widgets/custom_text_field.dart';
import 'package:flutter_gpt/utils/sample_question_api.dart';
import 'package:flutter_gpt/providers/open_ai_provider.dart';
import 'package:flutter_gpt/widgets/settings_bottomsheet.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen>
    with AutomaticKeepAliveClientMixin<ChatScreen> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    getRandomSampleQuestions();
  }

  @override
  void dispose() {
    super.dispose();
    _textEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          FocusScope.of(context).unfocus();
          return false;
        },
        child: Scaffold(
          backgroundColor: secondaryColor,
          appBar: AppBar(
            elevation: 0.0,
            backgroundColor: secondaryColor,
            automaticallyImplyLeading: false,
            title: Text(
              "GPT",
              style: GoogleFonts.poppins(
                fontSize: 24.0,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            actions: <Widget>[
              IconButton(
                onPressed: () {
                  SettingsBottomSheet.showSettingsBottomSheet(context: context);
                },
                icon: const Icon(
                  size: 25.0,
                  Icons.key,
                  color: Colors.white,
                ),
              )
            ],
          ),
          body: Consumer<OpenAIProvider>(
            builder: (context, openAIState, child) {
              return SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: <Widget>[
                    openAIState.chatMessages.isEmpty
                        ? SizedBox(
                            height: MediaQuery.of(context).size.height * 0.01)
                        : const SizedBox(),
                    openAIState.chatMessages.isEmpty
                        ? Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Examples",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          )
                        : const SizedBox(),
                    openAIState.chatMessages.isEmpty
                        ? Expanded(
                            child: ListView.builder(
                              itemCount: selectedQuestions.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 5.0,
                                    horizontal: 15.0,
                                  ),
                                  child: GestureDetector(
                                    onTap: () {
                                      openAIState.sendMessage(
                                        message: selectedQuestions[index],
                                      );
                                      _textEditingController.clear();
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.all(15.0),
                                      decoration: BoxDecoration(
                                        color: primaryColor,
                                        borderRadius:
                                            BorderRadius.circular(15.0),
                                      ),
                                      child: Text(
                                        selectedQuestions[index],
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white70,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          )
                        : Flexible(
                            child: ListView.builder(
                              itemCount: openAIState.chatMessages.length,
                              physics: const BouncingScrollPhysics(),
                              itemBuilder: (context, index) {
                                return ChatTile(
                                  sender:
                                      openAIState.chatMessages[index].sender!,
                                  message:
                                      openAIState.chatMessages[index].message!,
                                  isPlaying: false,
                                );
                              },
                            ),
                          ),
                    CustomTextField(
                      openAIState: openAIState,
                      textEditingController: _textEditingController,
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
