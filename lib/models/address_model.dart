class AddressModel {
  late int? _id;
  late String _addressType;
  late String _address;
  late String _latitude;
  late String _longitude;
  late String? _contactPersonName;
  late String? _contactPersonNumber;

  AddressModel({id, required addressType, address, latitude, longitude, contactPersonName, contactPersonNumber}) {
    _id = id;
    _addressType = addressType;
    _address = address;
    _latitude = latitude;
    _longitude = longitude;
    _contactPersonName = contactPersonName;
    _contactPersonNumber = contactPersonNumber;
  }

  String get addressType => _addressType;
  String get address => _address;
  String? get contactPersonName => _contactPersonName;
  String? get contactPersonNumber => _contactPersonNumber;
  String get latitude => _latitude;
  String get longitude => _longitude;

  AddressModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _addressType = json['address_type']??"";
    _address = json['address'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _contactPersonName = json['contact_person_name']??"";
    _contactPersonNumber = json['contact_person_number']??"";
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this._id;
    data['address_type'] = this._addressType;
    data['address'] = this._address;
    data['latitude'] = this._latitude;
    data['longitude'] = this._longitude;
    data['contact_person_name'] = this._contactPersonName;
    data['contact_person_number'] = this._contactPersonNumber;

    return data;
  }
}