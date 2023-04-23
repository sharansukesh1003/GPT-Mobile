// ignore_for_file: use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_gpt/api/open_ai_api.dart';
import 'package:flutter_gpt/utils/snackbars.dart';
import 'package:flutter_gpt/constants/constants.dart';
import 'package:flutter_gpt/utils/cache_service.dart';

class SettingsBottomSheet {
  static showSettingsBottomSheet({
    required BuildContext context,
  }) {
    TextEditingController textEditingController = TextEditingController();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 200.0,
            width: double.infinity,
            color: secondaryColor,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Update API key',
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Container(
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
                                controller: textEditingController,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: primaryColor,
                          ),
                          onPressed: () async {
                            if (await CacheService.getOpenAIAPIKey(
                                    key: "apiKey") ==
                                textEditingController.value.text) {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBars.apiKeySameError);
                            } else if (await OpenAIAPI.verifyOpenAIAPIKey(
                                apiKey: textEditingController.value.text)) {
                              await CacheService.updateAPIKey(
                                  newKey: textEditingController.value.text);
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBars.apiKeyUpdated);
                              Navigator.of(context).pop();
                            } else {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(SnackBars.incorrectAPIKey);
                            }
                          },
                          child: Text(
                            'Update',
                            style: GoogleFonts.poppins(
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                      ],
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
            ),
          ),
        );
      },
    );
  }
}
