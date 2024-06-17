import 'package:flutter/services.dart';


class AadhaarNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue previousValue,
      TextEditingValue nextValue,
      ) {
    var inputText = nextValue.text.replaceAll(" ", "");

    // Limit the input length to 12 characters
    if (inputText.length > 12) {
      inputText = inputText.substring(0, 12);
    }

    // List of invalid Aadhaar numbers
    const invalidAadhaarNumbers = {
      '000000000000',
      '111111111111',
      '222222222222',
      '333333333333',
      '444444444444',
      '555555555555',
      '666666666666',
      '777777777777',
      '888888888888',
      '999999999999'
    };

    // Check if the inputText is in the list of invalid Aadhaar numbers
    if (invalidAadhaarNumbers.contains(inputText)) {
      return previousValue; // Return the previous value if invalid
    }

    // Format the input text with spaces every 4 characters
    var bufferString = StringBuffer();
    for (int i = 0; i < inputText.length; i++) {
      bufferString.write(inputText[i]);
      var nonZeroIndexValue = i + 1;
      if (nonZeroIndexValue % 4 == 0 && nonZeroIndexValue != inputText.length) {
        bufferString.write(' ');
      }
    }

    var formattedString = bufferString.toString();
    return TextEditingValue(
      text: formattedString,
      selection: TextSelection.collapsed(
        offset: formattedString.length,
      ),
    );
  }
}