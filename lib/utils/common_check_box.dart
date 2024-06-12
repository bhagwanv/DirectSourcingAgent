import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';

import 'constant.dart';

class CommonCheckBox extends StatefulWidget {
  final ValueChanged<bool>? onChanged;
  final String? text;
  final bool upperCase;
  bool isChecked = false;

  CommonCheckBox({
    super.key,
    this.onChanged,
    this.text,
    this.upperCase = false,
    this.isChecked = false,
  });

  @override
  _CommonCheckBoxState createState() => _CommonCheckBoxState();
}

class _CommonCheckBoxState extends State<CommonCheckBox> {

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.isChecked = !widget.isChecked;
          widget.onChanged?.call(widget.isChecked);
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        child: Row(
          children: [
            Container(
              width: 24.0,
              height: 24.0,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.0,
                ),
                borderRadius: BorderRadius.circular(5.0),
              ),
              child: widget.isChecked
                  ? Container(
                color: (kPrimaryColor),
                child: Icon(
                  Icons.check,
                  size: 18.0,
                  color: Colors.white,
                ),

              )
                  : Container(),
            ),
            SizedBox(width: 18.0),
            Expanded(
              child: Text(
                widget.upperCase ? widget.text!.toUpperCase() : widget.text!,
                style: GoogleFonts.urbanist(
                  fontSize: 14,
                  color: blackSmall,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}