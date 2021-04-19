import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_doviz_app/models/currency_query.dart';
import 'package:flutter_doviz_app/models/currency_range.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../models/currency_type.dart';
import 'http_service.dart';

class DBHelper {
  static DBHelper _dbHelper;
  static Database _database;
  HttpRequest _httpRequest = HttpRequest();
  factory DBHelper() {
    if (_dbHelper == null) {
      _dbHelper = DBHelper.internal();
      return _dbHelper;
    } else {
      return _dbHelper;
    }
  }

  DBHelper.internal();

  Future<Database> _getDatabase() async {
    if (_database == null) {
      _database = await _initializeDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  //asset'ten db dosyası okuma
  Future<Database> _initializeDatabase() async {
    Database _db;

    var databasesPath = await getDatabasesPath();
    var path = join(databasesPath, "currency.db");

    var exists = await databaseExists(path);

    if (!exists) {
      print("assets klasöründen db oluşturuluyor..");

      try {
        await Directory(dirname(path)).create(recursive: true);
      } catch (_) {}

      // Copy from asset
      ByteData data = await rootBundle.load(join("assets", "currency.db"));
      List<int> bytes =
          data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

      // Write and flush the bytes written
      await File(path).writeAsBytes(bytes, flush: true);
    } else {
      print("varolan db açılıyor..$path");
    }

    _db = await openDatabase(path, readOnly: false);
    return _db;
  }

  //BASIC CRUD
  //
  Future<List<Map<String, dynamic>>> getAll(String table) async {
    var db = await _getDatabase();
    var result = await db.query(table);
    return result;
  }

  Future<List<CurrencyType>> getCurrencyList() async {
    try {
      var mapList = await getAll('currency_types');
      List<CurrencyType> _list = [];
      for (Map map in mapList) {
        _list.add(CurrencyType.fromMap(map));
      }
      return _list;
    } catch (e) {
      throw e;
    }
  }

  Future<int> addCurrency(CurrencyType currency) async {
    try {
      var db = await _getDatabase();
      var _check = await db.query("currency_types",
          where: 'currencyCode = ?', whereArgs: [currency.currencyCode]);
      if (_check.isEmpty) {
        var result = await db.insert("currency_types", currency.toMap());
        print('$result');
        return result;
      } else {
        return 0;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<int> addQuery(CurrencyQuery currencyQuery) async {
    try {
      var db = await _getDatabase();
      var _check = await db.query('currency_query',
          where: 'currencyId = ?', whereArgs: [currencyQuery.currencyId]);
      if (_check.isNotEmpty) {
        var _update = await db.update(
          'currency_query',
          {
            'startDate': currencyQuery.startDay,
            'endDate': currencyQuery.endDay
          },
          where: 'currencyId = ?',
          whereArgs: [currencyQuery.currencyId],
        );
        return _update;
      } else {
        var _insert = await db.insert('currency_query', currencyQuery.toMap());
        return _insert;
      }
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetData(CurrencyType currencyType) async {
    try {
      List<RangeValue> list = [];
      List<CurrencyRange> _dblist = [];
      var db = await _getDatabase();
      var _find = await db.rawQuery(
          'select currency_query.id,currency_types.currencyCode, currency_query.startDate, currency_query.endDate from currency_query' +
              ' inner join currency_types on currency_types.id = currency_query.currencyId where currency_types.id = ${currencyType.id}');
      list = await _httpRequest.getValueWithDate(
          _find[0]['currencyCode'], _find[0]['startDate'], _find[0]['endDate']);
      var _check = await db.query('currency_range',
          where: 'queryId=?', whereArgs: [_find[0]['id']]);
      if (_check.isNotEmpty) {
        await db.delete('currency_range',
            where: "queryId = ?", whereArgs: [_find[0]['id']]);
      }
      for (int i = 0; i < list.length; i++) {
        _dblist.add(CurrencyRange(_find[0]['id'], list[i].date,
            double.parse(list[i].alis), double.parse(list[i].satis)));
        await db.insert('currency_range', _dblist[i].toMap());
      }
    } catch (e) {
      throw e;
    }
  }

  Future<List<CurrencyRange>> getRangeData(int id) async {
    try {
      var db = await _getDatabase();
      var _check = await db.rawQuery(
          'select currency_range.queryId, currency_range.date, currency_range.selling, currency_range.buying from currency_range' +
              ' inner join currency_query on currency_query.id = currency_range.queryId' +
              ' inner join currency_types on currency_types.id = currency_query.currencyId where currency_types.id = $id ');
      List<CurrencyRange> _list = [];
      _check.forEach((element) {
        _list.add(CurrencyRange(element["queryId"], element["date"],
            element["buying"], element["selling"]));
      });
      return _list;
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      var db = await _getDatabase();
      var _getIds = await db.rawQuery(
          'select currency_range.queryId, currency_query.currencyId, currency_types.id from currency_range ' +
              'inner join currency_query on currency_query.id = currency_range.queryId ' +
              'inner join currency_types on currency_types.id = currency_query.currencyId where currency_types.id = ? GROUP BY(currency_types.id)',
          [id]);

      if (_getIds.length == 0) {
        _getIds =
            await db.query('currency_types', where: 'id = ?', whereArgs: [id]);
      } else {
        var _queryId, _currencyId;
        _queryId = _getIds[0]['queryId'];
        _currencyId = _getIds[0]['currencyId'];

        await db.delete('currency_range',
            where: 'queryId = ?', whereArgs: [_queryId]);
        await db.delete('currency_query',
            where: 'currencyId = ?', whereArgs: [_currencyId]);
      }
      var _id = _getIds[0]['id'];
      await db.delete('currency_types', where: 'id = ?', whereArgs: [_id]);
    } catch (e) {
      throw e;
    }
  }
}
