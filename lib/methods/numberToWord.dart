String convertNumberToWord(double number) {
  if (number == 0) {
    return 'zero';
  }

  if (number < 0) {
    return 'Invalid number';
  }

  String numberString = number.toString();
  List<String> parts = numberString.split('.');

  String wholePart = convertIntegerToWord(int.parse(parts[0]));
  String decimalPart = convertDecimalToWord(parts.length > 1 ? parts[1] : '0');

  if (decimalPart.isNotEmpty) {
    return '$wholePart point $decimalPart';
  } else {
    return wholePart;
  }
}

String convertIntegerToWord(int number) {
  if (number == 0) {
    return '';
  }

  if (number < 0) {
    return 'Invalid number';
  }

  List<String> units = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine', 'Ten',
    'Eleven', 'Twelve', 'Thirteen', 'Fourteen', 'Fifteen', 'Sixteen', 'Seventeen', 'Eighteen', 'Nineteen'
  ];

  List<String> tens = [
    '', '', 'Twenty', 'Thirty', 'Forty', 'Fifty', 'Sixty', 'Seventy', 'Eighty', 'Ninety'
  ];

  String word = '';
  int magnitude = 0;

  while (number > 0) {
    int remainder = magnitude>0?number%100:number % 1000;

    if (remainder != 0) {
      String part = convertThreeDigitNumber(remainder, units, tens);
      if (magnitude > 0) {
        part += ' ${getMagnitudeWord(magnitude)}';
      }
      word = part + (word.isNotEmpty ? ' $word' : '');
    }

    number ~/= magnitude>0?100:1000;
    magnitude++;
  }

  return word.trim();
}

String convertThreeDigitNumber(int number, List<String> units, List<String> tens) {
  String word = '';

  if (number >= 100) {
    word += '${units[number ~/ 100]} hundred';
    number %= 100;
  }

  if (number >= 20) {
    word += '${word.isNotEmpty ? ' ' : ''}${tens[number ~/ 10]}';
    number %= 10;
  }

  if (number > 0) {
    word += '${word.isNotEmpty ? ' ' : ''}${units[number]}';
  }

  return word;
}

String getMagnitudeWord(int magnitude) {
  List<String> magnitudes = ['', 'Thousand','Lac','Crore', 'Billion', 'Trillion', 'Quadrillion'];
  return magnitudes[magnitude];
}

String convertDecimalToWord(String decimal) {
  List<String> units = [
    '', 'One', 'Two', 'Three', 'Four', 'Five', 'Six', 'Seven', 'Eight', 'Nine'
  ];

  String word = '';

  for (int i = 0; i < decimal.length; i++) {
    int digit = int.parse(decimal[i]);
    word += '${units[digit]} ';
  }

  return word.trim();
}