import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/currency_provider.dart';
//screens
import '../screens/set_currency_screen.dart';
//widgets
import '../widgets/currency_widget.dart';
import '../widgets/calculate.dart';
import '../widgets/empty_list_widget.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    final _provider = Provider.of<CurrencyProvider>(context, listen: false);
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
          appBar: AppBar(
            title: Text("Döviz Uygulaması"),
            centerTitle: true,
          ),
          floatingActionButton: FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  builder: (_) {
                    return GestureDetector(
                      onTap: () {},
                      child: SetCurrencyScreen(),
                      behavior: HitTestBehavior.opaque,
                    );
                  });
            },
          ),
          body: Column(
            children: [
              CalculateCurrency(),
              FutureBuilder(
                  future: _provider.getCurrencyList(),
                  builder: (context, snapData) {
                    return Consumer<CurrencyProvider>(
                      builder: (context, _provider, _) {
                        return _provider.items.length != 0
                            ? Expanded(
                                child: RefreshIndicator(
                                  onRefresh: () => _provider.getCurrencyList(),
                                  child: ListView.builder(
                                      physics: const BouncingScrollPhysics(
                                          parent:
                                              AlwaysScrollableScrollPhysics()),
                                      primary: false,
                                      itemCount: _provider.items.length,
                                      itemBuilder: (context, i) {
                                        return Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: CurrencyWidget(
                                              _provider.items[i]),
                                        );
                                      }),
                                ),
                              )
                            : EmptyListWidget(
                                title: "Henüz para birimi eklemediniz.",
                                iconData: Icons.money_off,
                              );
                      },
                    );
                  }),
            ],
          )),
    );
  }
}

/*
*/
