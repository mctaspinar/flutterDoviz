import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../utils/currency_list.dart';

import '../models/currency_type.dart';
import '../models/currency_range.dart';

import '../providers/currency_provider.dart';

import '../screens/currency_update_screen.dart';

import '../widgets/date_range_list_widget.dart';
import '../widgets/chart_widget.dart';
import '../widgets/empty_list_widget.dart';

class DetailedScreen extends StatefulWidget {
  static const routeName = '/detailed-screen';

  @override
  _DetailedScreenState createState() => _DetailedScreenState();
}

class _DetailedScreenState extends State<DetailedScreen> {
  _done() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context).settings.arguments as CurrencyType;
    final _provider = Provider.of<CurrencyProvider>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Text(CurrencyMap.currency[arguments.currencyCode]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.date_range_outlined),
        onPressed: () {
          showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              builder: (_) {
                return GestureDetector(
                  onTap: () {},
                  child: CurrencyUpdateScreen(
                    done: _done,
                    data: arguments,
                  ),
                  behavior: HitTestBehavior.opaque,
                );
              });
        },
      ),
      body: Column(
        children: [
          FutureBuilder<List<CurrencyRange>>(
            future: _provider.getRangeValue(arguments.id),
            builder: (context, snapShot) {
              if (snapShot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                return snapShot.data.length != 0
                    ? Expanded(
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              height: MediaQuery.of(context).size.height * .5,
                              width: MediaQuery.of(context).size.width,
                              child: Card(
                                elevation: 7,
                                child: DataCharts(
                                  snapShot: snapShot,
                                  currency: arguments,
                                ),
                              ),
                            ),
                            Expanded(
                              child: DataListWidget(
                                snapShot: snapShot,
                              ),
                            )
                          ],
                        ),
                      )
                    : EmptyListWidget(
                        title: "Henüz bir veri eklemediniz.",
                        iconData: Icons.bar_chart,
                      );
              }
            },
          ),
        ],
      ),
    );
  }
}
