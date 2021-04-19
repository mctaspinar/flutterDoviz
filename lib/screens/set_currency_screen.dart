import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/currency_provider.dart';
import '../utils/currency_list.dart';
import '../models/currency_type.dart';

class SetCurrencyScreen extends StatefulWidget {
  static const routeName = '/new-currency-add';
  @override
  _SetCurrencyScreenState createState() => _SetCurrencyScreenState();
}

class _SetCurrencyScreenState extends State<SetCurrencyScreen> {
  var _currencyValue;
  var _currency = CurrencyType(null, '', '', '');
  String countryName, description;
  var _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<CurrencyProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Card(
        elevation: 5,
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                  hint: Text("Para Birimi Seçiniz"),
                  isExpanded: true,
                  value: _currencyValue,
                  items: CurrencyMap.currency
                      .map((key, description) {
                        return MapEntry(
                            key,
                            DropdownMenuItem<String>(
                              value: key,
                              child: Text(description),
                            ));
                      })
                      .values
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      _currencyValue = newValue;
                    });
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Ülke bilgisi giriniz'),
                  maxLines: 1,
                  maxLength: 100,
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Lütfen bu alanı boş bırakmayınız.";
                    } else {
                      return null;
                    }
                  },
                  onSaved: (value) {
                    setState(() {
                      countryName = value;
                    });
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Açıklama giriniz',
                  ),
                  maxLines: 1,
                  maxLength: 100,
                  onSaved: (value) {
                    setState(() {
                      description = value;
                    });
                  },
                  validator: (value) {
                    if (value.isEmpty) {
                      return "Lütfen bu alanı boş bırakmayınız.";
                    } else {
                      return null;
                    }
                  },
                ),
                SizedBox(
                  height: 10,
                ),
                OutlinedButton.icon(
                  onPressed: () async {
                    if (_formKey.currentState.validate()) {
                      _formKey.currentState.save();
                      _currency = CurrencyType(
                        int.parse(DateTime.now().millisecond.toString()),
                        _currencyValue,
                        countryName,
                        description,
                      );
                      var _result = await provider.addNewCurrency(_currency);
                      if (_result == 0) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                                "${CurrencyMap.currency[_currencyValue]} listenizde bulunmaktadır."),
                          ),
                        );
                      }
                      Navigator.of(context).pop();
                    }
                  },
                  icon: Icon(Icons.add),
                  label: Text("Para Birimini Ekle"),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
