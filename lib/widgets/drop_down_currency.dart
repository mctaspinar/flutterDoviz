import 'package:flutter/material.dart';

import '../utils/currency_list.dart';

class CurrencyButton extends StatefulWidget {
  @override
  _CurrencyButtonState createState() => _CurrencyButtonState();
}

class _CurrencyButtonState extends State<CurrencyButton> {
  var _currencyValue;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      hint: Text("Para Birimi Seçiniz"),
      isExpanded: true,
      value: _currencyValue,
      items: CurrencyMap.currency
          .map((key, description) {
            return MapEntry(
                key,
                DropdownMenuItem<String>(
                  value: key,
                  child: Text(
                    description,
                    textAlign: TextAlign.center,
                  ),
                ));
          })
          .values
          .toList(),
      onChanged: (newValue) {
        setState(() {
          _currencyValue = newValue;
        });
      },
    );
  }
}
