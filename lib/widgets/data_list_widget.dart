import 'package:flutter/material.dart';
import 'package:flutter_doviz_app/models/currency_type.dart';
import 'package:flutter_doviz_app/widgets/currency_widget.dart';

class UserCurrencyList extends StatefulWidget {
  final List<CurrencyType> list;
  UserCurrencyList({this.list});

  @override
  _UserCurrencyListState createState() => _UserCurrencyListState();
}

class _UserCurrencyListState extends State<UserCurrencyList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        primary: false,
        itemCount: widget.list.length,
        itemBuilder: (context, i) {
          return Padding(
              padding: const EdgeInsets.all(8.0),
              child: CurrencyWidget(widget.list[i]));
        });
  }
}
