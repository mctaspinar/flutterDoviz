import 'package:flutter/material.dart';

import '../services/http_service.dart';

class CurrentValue extends StatelessWidget {
  final String value;
  CurrentValue({this.value});
  HttpRequest _httpRequest = HttpRequest();
  @override
  Widget build(BuildContext context) {
    var _future = _httpRequest.getCurrentValue(value, DateTime.now());
    return FutureBuilder(
        future: _future,
        builder: (ctx, AsyncSnapshot<List<CurrentCurrency>> snapData) {
          if (snapData.connectionState == ConnectionState.waiting ||
              !snapData.hasData) {
            return Text("Yükleniyor..");
          } else {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text('Alış : ${snapData.data[0].alis} ₺'),
                  SizedBox(
                    width: 15,
                  ),
                  Text('Satış : ${snapData.data[0].satis} ₺'),
                ],
              ),
            );
          }
        });
  }
}
