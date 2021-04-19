import '../models/currency_type.dart';

class CurrencyQuery {
  int _id;
  CurrencyType _currencyId;
  String _startDay;
  String _endDay;

  get id => this._id;

  set id(int value) => this._id = value;

  get currencyId => this._currencyId.id;

  set currencyId(value) => this._currencyId = value;

  get startDay => this._startDay;

  set startDay(value) => this._startDay = value;

  get endDay => this._endDay;

  set endDay(value) => this._endDay = value;

  CurrencyQuery(this._currencyId, this._startDay, this._endDay);

  Map<String, dynamic> toMap() {
    var _temp = Map<String, dynamic>();
    _temp['id'] = id;
    _temp['currencyId'] = currencyId;
    _temp['startDate'] = startDay;
    _temp['endDate'] = endDay;
    return _temp;
  }

  CurrencyQuery.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    currencyId = map['currencyId'];
    startDay = map['startDate'];
    endDay = map['endDate'];
  }
}
