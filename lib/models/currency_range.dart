class CurrencyRange {
  int _id;
  int _queryId;
  String _date;
  double _buying;
  double _selling;

  get id => this._id;

  set id(int value) => this._id = value;

  get queryId => this._queryId;

  set queryId(value) => this._queryId = value;

  get date => this._date;

  set date(value) => this._date = value;

  get buying => this._buying;

  set buying(value) => this._buying = value;

  get selling => this._selling;

  set selling(value) => this._selling = value;

  CurrencyRange(this._queryId, this._date, this._buying, this._selling);

  Map<String, dynamic> toMap() {
    var _temp = Map<String, dynamic>();
    _temp['id'] = id;
    _temp['queryId'] = queryId;
    _temp['date'] = date;
    _temp['buying'] = buying;
    _temp['selling'] = selling;
    return _temp;
  }

  CurrencyRange.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    queryId = map['queryId'];
    date = map['date'];
    buying = map['buying'];
    selling = map['selling'];
  }
}
