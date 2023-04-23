import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SnackBars {
  static SnackBar incorrectAPIKey = SnackBar(
    duration: const Duration(seconds: 1),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    content: Text(
      "The API key provided is incorrect",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 14,
      ),
    ),
  );

  static SnackBar somethingWentWrong = SnackBar(
    duration: const Duration(seconds: 1),
    backgroundColor: Colors.red,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    content: Text(
      "Something Went Wrong!",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w600,
        color: Colors.white,
        fontSize: 14,
      ),
    ),
  );

  static SnackBar apiKeyUpdated = SnackBar(
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    content: Text(
      "Your API key has been updated successfully. However, in order for the changes to take effect, please kindly restart the application.",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 14,
      ),
    ),
  );

  static SnackBar apiKeySameError = SnackBar(
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.orange,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    content: Text(
      "The provided new API key is identical to the previous one.",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 14,
      ),
    ),
  );

  static SnackBar copiedToClipBoard = SnackBar(
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.green,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    content: Text(
      "Copied to clipboard",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 14,
      ),
    ),
  );

  static SnackBar audioBeingPlayed = SnackBar(
    margin: const EdgeInsets.only(bottom: 70.0, left: 5.0, right: 5.0),
    duration: const Duration(seconds: 3),
    backgroundColor: Colors.orange,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(
        Radius.circular(10),
      ),
    ),
    content: Text(
      "Please pause the the existing player",
      style: GoogleFonts.poppins(
        fontWeight: FontWeight.w500,
        color: Colors.white,
        fontSize: 14,
      ),
    ),
  );
}
