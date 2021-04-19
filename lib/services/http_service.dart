import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class HttpRequest {
  final _token = "gx5HbPCoUO";

  Future<List<CurrentCurrency>> getCurrentValue(
      String currency, DateTime startDay) async {
    var _day = findAndSetDay(startDay);
    String _url =
        "https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.$currency.S.YTL-TP.DK.$currency.A.YTL&startDate=$_day&endDate=$_day&type=json&key=$_token";
    Uri uri = Uri.parse(_url);
    try {
      List<CurrentCurrency> _tempList = [];
      final response = await http.get(uri);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) return [];

      data["items"].forEach((data) {
        _tempList.add(CurrentCurrency(
          satis: data['TP_DK_${currency}_S_YTL'],
          alis: data['TP_DK_${currency}_A_YTL'],
        ));
      });
      return _tempList;
    } catch (e) {
      throw e;
    }
  }

  Future<List<RangeValue>> getValueWithDate(
      String code, String sDay, String eDay) async {
    try {
      String _url =
          "https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.$code.S.YTL-TP.DK.$code.A.YTL&startDate=$sDay&endDate=$eDay&type=json&key=$_token";
      Uri uri = Uri.parse(_url);
      List<RangeValue> _tempList = [];
      final response = await http.get(uri);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) return [];

      data["items"].forEach((data) {
        if (data['TP_DK_${code}_S_YTL'] != null &&
            data['TP_DK_${code}_A_YTL'] != null)
          _tempList.add(RangeValue(
            date: data['Tarih'],
            satis: data['TP_DK_${code}_S_YTL'],
            alis: data['TP_DK_${code}_A_YTL'],
          ));
      });
      return _tempList;
    } catch (e) {
      throw e;
    }
  }

  Future<double> getCurrentSellingValue(
      String currencyCode, DateTime date) async {
    try {
      var _date = findAndSetDay(date);
      String _url =
          "https://evds2.tcmb.gov.tr/service/evds/series=TP.DK.$currencyCode.S.YTL&startDate=$_date&endDate=$_date&type=json&key=$_token";
      Uri uri = Uri.parse(_url);
      final response = await http.get(uri);
      final data = json.decode(response.body) as Map<String, dynamic>;
      if (data == null) return 0.0;
      return double.parse(data['items'][0]['TP_DK_${currencyCode}_S_YTL']);
    } catch (e) {
      throw e;
    }
  }

  //value is coming null at the weekend
  //fixed
  String findAndSetDay(DateTime startDay) {
    try {
      DateTime _tempDate = startDay;
      if (_tempDate.weekday == 6) {
        _tempDate = DateTime.now().subtract(Duration(days: 1));
      } else if (_tempDate.weekday == 7) {
        _tempDate = DateTime.now().subtract(Duration(days: 2));
      }
      return DateFormat('dd-MM-yyyy').format(_tempDate);
    } catch (e) {
      throw e;
    }
  }
}

class CurrentCurrency {
  final String satis;
  final String alis;

  CurrentCurrency({this.satis, this.alis});
}

class RangeValue {
  final String date;
  final String satis;
  final String alis;

  RangeValue({this.date, this.alis, this.satis});
}
