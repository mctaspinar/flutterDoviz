import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../widgets/date_range_list_widget.dart';

import '../models/currency_type.dart';
import '../models/currency_range.dart';

class DataCharts extends StatefulWidget {
  final AsyncSnapshot<List<CurrencyRange>> snapShot;
  final CurrencyType currency;
  DataCharts({this.snapShot, this.currency});
  @override
  _DataChartsState createState() => _DataChartsState();
}

class _DataChartsState extends State<DataCharts> {
  List<CurrencyRange> _chartData;
  TooltipBehavior _tooltipBehavior;
  @override
  void initState() {
    _chartData = getData();
    _tooltipBehavior = TooltipBehavior(enable: true);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: widget.snapShot.connectionState != ConnectionState.waiting
          ? SfCartesianChart(
              zoomPanBehavior: ZoomPanBehavior(
                enablePinching: true,
                enablePanning: true,
                zoomMode: ZoomMode.xy,
              ),
              primaryXAxis: CategoryAxis(),
              title: ChartTitle(text: widget.currency.countryName),
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              tooltipBehavior: _tooltipBehavior,
              series: <ChartSeries>[
                LineSeries<CurrencyRange, String>(
                  name: widget.currency.currencyCode,
                  dataSource: _chartData,
                  xValueMapper: (CurrencyRange currency, _) {
                    var dateString =
                        DataListWidget.dateFormatting(currency.date) +
                            ' 00:00:00';
                    return DateFormat('dd MMM')
                        .format(DateTime.parse(dateString));
                  },
                  yValueMapper: (CurrencyRange currency, _) =>
                      double.parse((currency.selling).toStringAsFixed(2)),
                  dataLabelSettings: DataLabelSettings(isVisible: true),
                )
              ],
            )
          : CircularProgressIndicator(),
    );
  }

  List<CurrencyRange> getData() {
    final List<CurrencyRange> chartData = [];
    widget.snapShot.data.forEach((element) {
      chartData.add(element);
    });
    return chartData;
  }
}
