import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'constant.dart';

class CommonElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final bool upperCase;
  final double textSize;

  const CommonElevatedButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.upperCase = false,
    this.textSize = 16.0,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
        minimumSize: MaterialStateProperty.all<Size>(
          Size(MediaQuery.of(context).size.width, 58),
        ),
        backgroundColor: MaterialStateProperty.all<Color>(kPrimaryColor),
        foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: onPressed,
      child: upperCase
          ? Text(text.toUpperCase(),
              style: GoogleFonts.urbanist(
                fontSize: textSize,
                fontWeight: FontWeight.w700,
              ))
          : Text(
              text,
              style: GoogleFonts.urbanist(
                fontSize: textSize,
                fontWeight: FontWeight.w700,
              ),
            ),
    );
  }
}
