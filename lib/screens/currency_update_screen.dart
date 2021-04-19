import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/currency_query.dart';
import '../models/currency_type.dart';

import '../providers/currency_provider.dart';

class CurrencyUpdateScreen extends StatefulWidget {
  static const routeName = '/update-screen';

  final Function done;
  final CurrencyType data;
  CurrencyUpdateScreen({this.done, this.data});

  @override
  _CurrencyUpdateScreenState createState() => _CurrencyUpdateScreenState();
}

class _CurrencyUpdateScreenState extends State<CurrencyUpdateScreen> {
  var _dateStartString = 'Başlangıç tarihi';
  var _dateEndString = 'Bitiş tarihi';
  var _setDate, _startDate, _endDate;
  bool _isLoading = true;
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CurrencyProvider>(context, listen: false);
    return SingleChildScrollView(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Text(
                  "Tarih Aralığı Seçiniz",
                  style: Theme.of(context).textTheme.headline5.copyWith(
                        color: Colors.black,
                      ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                locale: Locale('tr'),
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2002),
                                lastDate: DateTime.now())
                            .then((value) {
                          setState(() {
                            print(value);
                            _dateStartString =
                                DateFormat.yMMMMd('tr_TR').format(value);
                            _setDate = value;
                            _startDate = value;
                          });
                        });
                      },
                      child: Text(_dateStartString),
                      style: TextButton.styleFrom(
                          textStyle: TextStyle(fontSize: 20))),
                  TextButton(
                    onPressed: () {
                      if (_setDate == null) return;
                      showDatePicker(
                              context: context,
                              locale: Locale('tr'),
                              initialDate: DateTime.now(),
                              firstDate: _setDate,
                              lastDate: DateTime.now())
                          .then((value) {
                        setState(() {
                          print(value);
                          _dateEndString =
                              DateFormat.yMMMMd('tr_TR').format(value);
                          _endDate = value;
                        });
                      });
                    },
                    child: Text(_dateEndString),
                    style: TextButton.styleFrom(
                        textStyle: TextStyle(fontSize: 20)),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Ülke : ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      '${widget.data.countryName}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Açıklama : ',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    Text(
                      '${widget.data.description}',
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              OutlinedButton(
                onPressed: _isLoading
                    ? () async {
                        if (_startDate == null || _endDate == null) return;
                        if (_startDate.day == _endDate.day) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                  "Lütfen tarih aralığını en az 1 gün olacak şekilde seçiniz."),
                            ),
                          );
                        } else {
                          var _newQuery = CurrencyQuery(
                              widget.data,
                              DateFormat('dd-MM-yyyy').format(_startDate),
                              DateFormat('dd-MM-yyyy').format(_endDate));
                          await _provider.addNewQuery(_newQuery);
                          setState(() {
                            _isLoading = false;
                          });
                          await _provider.fetchAndSetData(widget.data);
                          widget.done();
                          Navigator.of(context).pop();
                        }
                      }
                    : null,
                child: Text(_isLoading ? "Verileri Getir" : "Yükleniyor"),
                style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Theme.of(context).accentColor)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
