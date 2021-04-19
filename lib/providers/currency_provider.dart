import 'package:flutter/material.dart';

import '../models/currency_query.dart';
import '../models/currency_type.dart';
import '../models/currency_range.dart';

import '../services/db_helper.dart';

class CurrencyProvider with ChangeNotifier {
  List<CurrencyType> _items = [];

  List<CurrencyType> get items {
    return [..._items];
  }

  DBHelper _dbHelper = DBHelper();

  Future<int> addNewCurrency(CurrencyType currencyTypes) async {
    try {
      final _result = await _dbHelper.addCurrency(currencyTypes);
      if (_result != 0) {
        _items.add(currencyTypes);
      }
      notifyListeners();
      return _result;
    } catch (e) {
      throw e;
    }
  }

  Future<int> addNewQuery(CurrencyQuery currencyQuery) async {
    try {
      final _result = await _dbHelper.addQuery(currencyQuery);
      return _result;
    } catch (e) {
      throw e;
    }
  }

  Future<List<CurrencyType>> getCurrencyList() async {
    try {
      final _result = await _dbHelper.getCurrencyList();
      _items = _result;
      notifyListeners();
      return _result;
    } catch (e) {
      throw e;
    }
  }

  Future<List<CurrencyRange>> getRangeValue(int id) async {
    try {
      final _result = await _dbHelper.getRangeData(id);
      return _result;
    } catch (e) {
      throw e;
    }
  }

  Future<void> deleteItem(int id) async {
    try {
      await _dbHelper.deleteItem(id);
      final existingIndex = _items.indexWhere((element) => element.id == id);
      _items.removeAt(existingIndex);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetData(CurrencyType currencyType) async {
    try {
      var result = await _dbHelper.fetchAndSetData(currencyType);
      return result;
    } catch (e) {
      return false;
    }
  }
}
