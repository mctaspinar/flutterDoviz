import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/currency_range.dart';

class DataListWidget extends StatelessWidget {
  final AsyncSnapshot<List<CurrencyRange>> snapShot;
  DataListWidget({this.snapShot});

  static String dateFormatting(String s) {
    var list = s.split('-');
    var count = list.length;
    String temp = '';
    for (int i = list.length - 1; i > -1; i--) {
      temp += (list[i]);
      while (count > 1) {
        temp += '-';
        count--;
        break;
      }
    }
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: snapShot.data.length,
        itemBuilder: (context, i) {
          var _list = snapShot.data.reversed.toList();
          String _dateString = dateFormatting(_list[i].date) + ' 00:00:00';
          var castingDateTime = DateTime.parse(_dateString);
          return Column(
            children: [
              ListTile(
                title: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    DateFormat.yMMMMEEEEd().format(castingDateTime),
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
                subtitle: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Alış : ${_list[i].buying.toStringAsFixed(2)} ₺'),
                    SizedBox(
                      width: 15,
                    ),
                    Text('Satış : ${_list[i].selling.toStringAsFixed(2)} ₺'),
                  ],
                ),
              ),
              Divider(),
            ],
          );
        });
  }
}
