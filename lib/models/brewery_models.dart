class BreweryModel {
  int _id;
  String _name;
  String _breweryType;
  String _street;
  String _city;
  String _state;
  String _postalCode;
  String _country;
  String _longitude;
  String _latitude;
  String _phone;
  String _websiteUrl;
  String _updatedAt;

  BreweryModel(
      {int id,
        String name,
        String breweryType,
        String street,
        String city,
        String state,
        String postalCode,
        String country,
        String longitude,
        String latitude,
        String phone,
        String websiteUrl,
        String updatedAt}) {
    this._id = id;
    this._name = name;
    this._breweryType = breweryType;
    this._street = street;
    this._city = city;
    this._state = state;
    this._postalCode = postalCode;
    this._country = country;
    this._longitude = longitude;
    this._latitude = latitude;
    this._phone = phone;
    this._websiteUrl = websiteUrl;
    this._updatedAt = updatedAt;
  }

  int get id => _id;
  set id(int id) => _id = id;
  String get name => _name;
  set name(String name) => _name = name;
  String get breweryType => _breweryType;
  set breweryType(String breweryType) => _breweryType = breweryType;
  String get street => _street;
  set street(String street) => _street = street;
  String get city => _city;
  set city(String city) => _city = city;
  String get state => _state;
  set state(String state) => _state = state;
  String get postalCode => _postalCode;
  set postalCode(String postalCode) => _postalCode = postalCode;
  String get country => _country;
  set country(String country) => _country = country;
  String get longitude => _longitude;
  set longitude(String longitude) => _longitude = longitude;
  String get latitude => _latitude;
  set latitude(String latitude) => _latitude = latitude;
  String get phone => _phone;
  set phone(String phone) => _phone = phone;
  String get websiteUrl => _websiteUrl;
  set websiteUrl(String websiteUrl) => _websiteUrl = websiteUrl;
  String get updatedAt => _updatedAt;
  set updatedAt(String updatedAt) => _updatedAt = updatedAt;

  BreweryModel.fromJson(Map<dynamic, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _breweryType = json['brewery_type'];
    _street = json['street'];
    _city = json['city'];
    _state = json['state'];
    _postalCode = json['postal_code'];
    _country = json['country'];
    _longitude = json['longitude'];
    _latitude = json['latitude'];
    _phone = json['phone'];
    _websiteUrl = json['website_url'];
    _updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['brewery_type'] = this._breweryType;
    data['street'] = this._street;
    data['city'] = this._city;
    data['state'] = this._state;
    data['postal_code'] = this._postalCode;
    data['country'] = this._country;
    data['longitude'] = this._longitude;
    data['latitude'] = this._latitude;
    data['phone'] = this._phone;
    data['website_url'] = this._websiteUrl;
    data['updated_at'] = this._updatedAt;
    return data;
  }
}
