import 'dart:async';

import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';

import '../services/http_service.dart';
import '../utils/currency_list.dart';

class CalculateCurrency extends StatefulWidget {
  @override
  _CalculateCurrencyState createState() => _CalculateCurrencyState();
}

class _CalculateCurrencyState extends State<CalculateCurrency> {
  var _controllerCurrency = TextEditingController();
  var _controllerTRY = TextEditingController();
  var _currencyValue = 'USD';
  var _currentValue;
  bool _isOnline = true;
  HttpRequest _httpRequest = HttpRequest();

  Future<double> _future() async {
    var _result = await Connectivity().checkConnectivity();
    if (_result == ConnectivityResult.none) {
      _currentValue = 0.0;
    } else {
      _currentValue = await _httpRequest.getCurrentSellingValue(
          _currencyValue, DateTime.now());
    }
    return _currentValue;
  }

  var _isInit = true;
  Future<void> _checkConnectivity() async {
    var _result = await Connectivity().checkConnectivity();
    if (_result == ConnectivityResult.none) {
      _isOnline = false;
    } else {
      _isOnline = true;
    }
    return _result;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _checkConnectivity();
    }
    if (_isOnline) _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    _currentValue = _future();
    return Container(
      padding: const EdgeInsets.only(bottom: 30),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(
            height: 20,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: 300, minWidth: 300),
            child: DropdownButtonHideUnderline(
              child: DropdownButton(
                itemHeight: 60,
                value: _currencyValue,
                items: CurrencyMap.currency
                    .map((key, description) {
                      return MapEntry(
                          key,
                          DropdownMenuItem<String>(
                            value: key,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                description,
                              ),
                            ),
                          ));
                    })
                    .values
                    .toList(),
                onChanged: (newValue) {
                  setState(() {
                    _currentValue = _future();
                    _currencyValue = newValue;
                    _controllerCurrency.text = "";
                    _controllerTRY.text = "";
                  });
                },
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(25),
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 25,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                width: 150,
                height: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: _controllerCurrency,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    hintText: _currencyValue,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && double.tryParse(value) != null) {
                      _controllerTRY.text =
                          (double.parse(value) * _currentValue)
                              .toStringAsFixed(2);
                    } else {
                      _controllerTRY.text = "";
                    }
                  },
                ),
              ),
              Icon(
                Icons.compare_arrows_outlined,
                size: 50,
                color: Colors.white,
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(25),
                  color: Colors.white,
                ),
                width: 150,
                height: 60,
                child: TextField(
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  controller: _controllerTRY,
                  style: TextStyle(fontSize: 20),
                  decoration: InputDecoration(
                    filled: true,
                    hintText: 'TRY',
                    hintStyle: TextStyle(),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onChanged: (value) {
                    if (value.isNotEmpty && double.tryParse(value) != null) {
                      _controllerCurrency.text =
                          (double.parse(value) / _currentValue)
                              .toStringAsFixed(2);
                    } else {
                      _controllerCurrency.text = "";
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
