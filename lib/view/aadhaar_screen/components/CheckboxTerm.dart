import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../utils/constant.dart';

class CheckboxTerm extends StatefulWidget {
  final String? content;
  bool isChecked = false;
  final ValueChanged<bool>? onChanged;

  CheckboxTerm({super.key, this.content, this.isChecked = false, this.onChanged});

  @override
  State<CheckboxTerm> createState() => _CheckboxTermState();
}

class _CheckboxTermState extends State<CheckboxTerm> {

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return  InkWell(
        splashColor: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Checkbox(
            checkColor: Colors.white,
            value: widget.isChecked,
            side: const BorderSide(color: kPrimaryColor),
            onChanged: (bool? value) {
              setState(() {
                widget.isChecked = value!;
                widget.onChanged!(value);
              });
            },
          ),

          Expanded(
            child: Text(
              widget.content ?? "",
              textAlign: TextAlign.justify,
              style: TextStyle(fontSize: 14.0,),
            ),),
        ]),onTap: () {
      // Toggle checkbox state when the row is tapped
      setState(() {
        widget.isChecked = !widget.isChecked;
        widget.onChanged!(widget.isChecked);
      });
    },) ;
  }
}