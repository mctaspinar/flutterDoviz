import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import './screens/home_screen.dart';
import './screens/currency_update_screen.dart';
import './screens/detailed_currency_screen.dart';

import './utils/custom_theme_data.dart';

import 'providers/currency_provider.dart';

void main() {
  Intl.defaultLocale = 'tr_TR';

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => CurrencyProvider()),
      ],
      child: MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: [
          const Locale('en', 'US'),
          const Locale('tr', 'TR  '),
        ],
        debugShowCheckedModeBanner: false,
        title: 'Döviz Uygulaması',
        theme: CustomThemeData.val,
        home: HomeScreen(),
        routes: {
          DetailedScreen.routeName: (_) => DetailedScreen(),
          CurrencyUpdateScreen.routeName: (_) => CurrencyUpdateScreen(),
        },
      ),
    );
  }
}
