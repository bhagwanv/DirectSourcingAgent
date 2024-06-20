import 'package:flutter/material.dart';

class CustomRadioButton extends StatelessWidget {
  final String value;
  final String groupValue;
  final ValueChanged<String> onChanged;
  final String text;

  CustomRadioButton({
    required this.value,
    required this.groupValue,
    required this.onChanged,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final bool isSelected = value == groupValue;

    return GestureDetector(
      onTap: () => onChanged(value),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(4.0),
              border: Border.all(
                color: isSelected ? Colors.blue : Colors.grey,
                width: 2.0,
              ),
            ),
            width: 18.0,
            height: 18.0,
            child: isSelected
                ? Center(
                    child: Icon(
                      Icons.check,
                      size: 14.0,
                      color: Colors.blue,
                    ),
                  )
                : null,
          ),
          SizedBox(width: 8.0),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }
}
