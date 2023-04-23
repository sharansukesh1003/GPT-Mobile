// ignore_for_file: use_build_context_synchronously
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gpt/utils/snackbars.dart';
import 'package:flutter_gpt/api/open_ai_api.dart';
import 'package:flutter_gpt/constants/constants.dart';
import 'package:flutter_gpt/screens/chat_screen.dart';
import 'package:flutter_gpt/utils/cache_service.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:introduction_screen/introduction_screen.dart';

class CustomIntroductionScreen extends StatefulWidget {
  const CustomIntroductionScreen({
    super.key,
  });

  @override
  State<CustomIntroductionScreen> createState() =>
      _CustomIntroductionScreenState();
}

class _CustomIntroductionScreenState extends State<CustomIntroductionScreen> {
  bool isQuestionComplete = false;
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: IntroductionScreen(
        done: Text(
          'Get Started',
          style: GoogleFonts.poppins(
            color: Colors.white54,
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
          ),
        ),
        onDone: () async {
          if (await OpenAIAPI.verifyOpenAIAPIKey(
              apiKey: _textEditingController.value.text)) {
            await CacheService.setOpenAIAPIKey(
                    apiKey: _textEditingController.value.text)
                .then(
              (value) => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (cntx) => const ChatScreen(),
                ),
              ),
            );
          } else {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBars.incorrectAPIKey);
          }
        },
        pages: [
          PageViewModel(
            titleWidget: RichText(
              text: TextSpan(
                text: 'Now use',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' GPT ',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                    ),
                  ),
                  TextSpan(
                    text: 'from your phone',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),
            ),
            bodyWidget: Column(
              children: <Widget>[
                Text(
                  screenOneMessage,
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: AnimatedTextKit(
                    onFinished: () {
                      setState(() {
                        isQuestionComplete = true;
                      });
                    },
                    animatedTexts: [
                      TypewriterAnimatedText(
                        cursor: "",
                        sampleGPTQuestion,
                        textStyle: GoogleFonts.poppins(
                          fontWeight: FontWeight.w300,
                          color: Colors.white70,
                          fontSize: 14.0,
                        ),
                        speed: const Duration(milliseconds: 100),
                      ),
                    ],
                    totalRepeatCount: 1,
                    pause: const Duration(milliseconds: 100),
                  ),
                ),
                isQuestionComplete
                    ? Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(15.0),
                        margin: const EdgeInsets.only(top: 10.0),
                        decoration: BoxDecoration(
                          color: secondaryColor,
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: AnimatedTextKit(
                          animatedTexts: [
                            TypewriterAnimatedText(
                              cursor: "",
                              sampleGPTResponse,
                              textStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w300,
                                color: Colors.white70,
                                fontSize: 14.0,
                              ),
                              speed: const Duration(milliseconds: 50),
                            ),
                          ],
                          totalRepeatCount: 1,
                          pause: const Duration(milliseconds: 500),
                          displayFullTextOnTap: true,
                          stopPauseOnTap: true,
                        ),
                      )
                    : const SizedBox(),
              ],
            ),
          ),
          PageViewModel(
            titleWidget: RichText(
              text: TextSpan(
                text: 'Enter your',
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 28.0,
                ),
                children: <TextSpan>[
                  TextSpan(
                    text: ' API ',
                    style: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontWeight: FontWeight.bold,
                      fontSize: 32.0,
                    ),
                  ),
                  TextSpan(
                    text: 'key to get started',
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 28.0,
                    ),
                  ),
                ],
              ),
            ),
            bodyWidget: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  screenTwoMessage,
                  style: GoogleFonts.poppins(
                    color: Colors.white38,
                    fontWeight: FontWeight.w500,
                    fontSize: 16.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Step 1",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: RichText(
                    text: TextSpan(
                      text:
                          "If you don't have an account, please go to the OpenAI website and sign up ",
                      style: GoogleFonts.poppins(
                        fontSize: 14.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w300,
                      ),
                      children: <TextSpan>[
                        TextSpan(
                          recognizer: TapGestureRecognizer()
                            ..onTap = () async {
                              if (!await launchUrl(
                                Uri.parse(openAIURL),
                                mode: LaunchMode.externalApplication,
                              )) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBars.somethingWentWrong);
                              }
                            },
                          text: 'OpenAI',
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text:
                              ". Once you have logged in, you will be redirected to the ",
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: "API Keys",
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " section. Click on ",
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        TextSpan(
                          text: "Create Secret Key",
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        TextSpan(
                          text: " and then copy it.",
                          style: GoogleFonts.poppins(
                            fontSize: 14.0,
                            color: Colors.white,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Step 2",
                    style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(15.0),
                  margin: const EdgeInsets.only(top: 10.0),
                  decoration: BoxDecoration(
                    color: secondaryColor,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                        text: TextSpan(
                            text:
                                "Paste your API key into the text field below, and then click on ",
                            style: GoogleFonts.poppins(
                              fontSize: 14.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            children: [
                              TextSpan(
                                text: "Get Started",
                                style: GoogleFonts.poppins(
                                  fontSize: 14.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ]),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 15.0, bottom: 5.0),
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 1.0,
                            color: Colors.white70,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20.0,
                          ),
                          child: TextField(
                            obscureText: true,
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintStyle: GoogleFonts.poppins(
                                fontSize: 16.0,
                                color: Colors.white70,
                                fontWeight: FontWeight.w300,
                              ),
                              hintText: "*********************************",
                            ),
                            cursorColor: Colors.white70,
                            style: GoogleFonts.poppins(
                              fontSize: 16.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w300,
                            ),
                            controller: _textEditingController,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(5.0),
                        child: Text(
                          "Enter API Key",
                          style: GoogleFonts.poppins(
                            color: Colors.white70,
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
        showNextButton: true,
        globalBackgroundColor: primaryColor,
        dotsDecorator: const DotsDecorator(
          color: secondaryColor,
          size: Size.square(10.0),
          activeSize: Size.square(15.0),
          activeColor: Colors.white,
        ),
        next: Container(
          width: 30,
          height: 30,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: secondaryColor,
          ),
          child: const Icon(
            Icons.navigate_next,
            size: 30,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
