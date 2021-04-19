class CurrencyType {
  int _id;
  String _currencyCode;
  String _countryName;
  String _description;

  get id => this._id;

  set id(value) => this._id = value;

  get currencyCode => this._currencyCode;

  set currencyCode(value) => this._currencyCode = value;

  get countryName => this._countryName;

  set countryName(value) => this._countryName = value;

  get description => this._description;

  set description(value) => this._description = value;

  CurrencyType(
    this._id,
    this._currencyCode,
    this._countryName,
    this._description,
  );

  @override
  String toString() {
    return 'CurrencyType{_currencyCode: $_currencyCode}';
  }

  Map<String, dynamic> toMap() {
    var _temp = Map<String, dynamic>();
    _temp['id'] = id;
    _temp['currencyCode'] = currencyCode;
    _temp['countryName'] = countryName;
    _temp['description'] = description;
    return _temp;
  }

  CurrencyType.fromMap(Map<String, dynamic> map) {
    id = map['id'];
    currencyCode = map['currencyCode'];
    countryName = map['countryName'];
    description = map['description'];
  }
}
