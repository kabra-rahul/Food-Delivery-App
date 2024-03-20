import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:food_delivery/data/api/api_checker.dart';
import 'package:food_delivery/data/repository/location_repo.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../models/address_model.dart';
import '../models/response_model.dart';
import 'package:google_maps_webservice/src/places.dart';
import 'package:geolocator_platform_interface/src/models/position.dart';

class LocationController extends GetxController implements GetxService {

  LocationRepo locationRepo;

  LocationController({required this.locationRepo});

  bool _loading = false;
  late Position _position;
  late Position _pickPosition;
  Placemark _placemark = Placemark();
  Placemark _pickPlacemark = Placemark();
  List<AddressModel> _addressList = [];
  late List<AddressModel> _allAddressList;
  List<String> _addressTypeList = ["Home","Office","Others"];
  int _addressTypeIndex = 0;
  late Map<String, dynamic> _getAddress;
  late GoogleMapController _googleMapController;
  bool _updateAddressData = true;
  bool _changeAddress = true;

  //for service zone
  bool _isloading = false;
  bool get isLoading => _isloading;
  // whether the  user is in service zone
  bool _inZone = true;
  bool get inZone => _inZone;
  // for showing and hiding the button as map loads
  bool _buttonDisable = true;
  bool get buttonDisable => _buttonDisable;
  //save the google map suggestions for autocomplete address
  List<Prediction> _predictionList = [];
  List<Prediction> get predictionList => _predictionList;

  bool get loading => _loading;
  Position get position => _position;
  Position get pickPosition => _pickPosition;
  Map get getAddress => _getAddress;
  List<AddressModel> get addressList => _addressList;
  List<AddressModel> get allAddressList => _allAddressList;
  Placemark get placemark => _placemark;
  Placemark get pickPlacemark => _pickPlacemark;
  List<String> get addressTypeList => _addressTypeList;
  int get addressTypeIndex => _addressTypeIndex;
  GoogleMapController get googleMapController => _googleMapController;


  void setMapController( GoogleMapController controller) {
    _googleMapController = controller;
  }


  Future<void> updatePosition(CameraPosition position, bool fromAddress) async {
    if(_updateAddressData) {
      _loading = true;
      update();

      try {
         if(fromAddress) {
           _position = Position(
              latitude: position.target.latitude,
              longitude: position.target.longitude,
             timestamp: DateTime.now(),
             accuracy: 1,
             altitude: 1,
             heading: 1,
             speed: 1,
             speedAccuracy: 1
           );
         }
         else {
           _pickPosition = Position(
               latitude: position.target.latitude,
               longitude: position.target.longitude,
               timestamp: DateTime.now(),
               accuracy: 1,
               altitude: 1,
               heading: 1,
               speed: 1,
               speedAccuracy: 1
           );
         }

         ResponseModel _responseModel = await getZone(position.target.latitude.toString(), position.target.longitude.toString(), false);
        //if buttonDisable value is false its in service area
         _buttonDisable = !_responseModel.isSuccess;

         if(_changeAddress) {
           String _address = await getAddressFromGeoCode( LatLng(position.target.latitude, position.target.longitude));

           fromAddress?_placemark=Placemark(name: _address):_pickPlacemark=Placemark(name: _address);
         } else{
           _changeAddress = true;
         }
      } catch(e){
        print(e);
      }

      _loading = false;
      update();
    }
    else{
      _updateAddressData = true;
    }
  }


  Future<String> getAddressFromGeoCode(LatLng latlng) async {
    String _address = "Unknown Location Found";
    Response response = await locationRepo.getAddressFromGeoCode(latlng);

    if(response.body["status"]=='OK') {
      _address = response.body['results'][0]['formatted_address'].toString();
    }
    else {
      print("Error in getting location");
    }
    update();
    return _address;
  }


  AddressModel getUserAddress() {
    late AddressModel _addressModel;
    _getAddress = jsonDecode(locationRepo.getUserAddress());
    try {
      _addressModel =  AddressModel.fromJson(jsonDecode(locationRepo.getUserAddress()));
    } catch(e) {
      print(e);
    }
    return _addressModel;
  }


  setAddressType(int index){
    _addressTypeIndex = index;
    update();
  }


  Future<ResponseModel> addAddress(AddressModel addressModel) async {
    _loading = true;
    update();
    Response response = await locationRepo.addAddress(addressModel);
    late ResponseModel responseModel;
    if(response.statusCode == 200) {
      await getAddressList();
      responseModel = ResponseModel(true,response.body["message"] );
      await saveUserAddress(addressModel);
    } else {
      responseModel = ResponseModel(false,response.statusText!);
    }
    _loading = false;
    update();
    return responseModel;
  }


  Future<void> getAddressList() async {
    Response response = await locationRepo.getAllAddress();

    if(response.statusCode == 200) {
      _addressList = [];
      _allAddressList = [];
      response.body.forEach((address){
          _addressList.add(AddressModel.fromJson(address));
          _allAddressList.add(AddressModel.fromJson(address));
      });
    } else {
      _addressList = [];
      _allAddressList = [];
    }
    update();
  }


  Future<bool> saveUserAddress(AddressModel addressModel) async {
    String userAddress = jsonEncode(addressModel.toJson());
    return await locationRepo.saveUserAddress(userAddress);
  }


  clearAddressList(){
    _addressList = [];
    _allAddressList = [];
    update();
  }


  String getUserAddressFromLocalStorage() {
    return locationRepo.getUserAddress();
  }


  void setAddAddressData() {
    _position  = _pickPosition;
    _placemark = _pickPlacemark;
    _updateAddressData = false;
    update();
  }


  Future<ResponseModel> getZone(String lat, String lng, bool markerLoad) async {
    late ResponseModel _responseModel;
    if(markerLoad){
      _loading = true;
    } else {
      _isloading = true;
    }
    update();
    Response _response = await locationRepo.getZone(lat, lng);
    if(_response.statusCode == 200) {
      _inZone = true;
      _responseModel = ResponseModel(true,_response.body["zone_id"].toString() );
    } else {
      _inZone = false;
      _responseModel = ResponseModel(false,_response.statusText!);
    }

    if(markerLoad){
      _loading = false;
    } else {
      _isloading = false;
    }
    update();
    return _responseModel;
  }


  Future<List<Prediction>> searchLocation(BuildContext context, String text) async {
    if(text.isNotEmpty) {
      Response response = await locationRepo.searchLocation(text);

      if(response.statusCode==200 && response.body['status']=='OK') {
        _predictionList = [];
        response.body['predictions'].forEach((prediction)=>_predictionList.add(Prediction.fromJson(prediction)));
      } else {
        ApiChecker.checkApi(response);
      }
    }
    return _predictionList;
  }


  setLocation(String placeId, String address, GoogleMapController mapController) async {
    _loading = true;
    update();

    PlacesDetailsResponse details;
    Response response = await locationRepo.setLocation(placeId);
    details = PlacesDetailsResponse.fromJson(response.body);
    _pickPosition = Position(
        latitude: details.result.geometry!.location.lat,
        longitude: details.result.geometry!.location.lng,
        timestamp: DateTime.now(),
        accuracy: 1,
        altitude: 1,
        heading: 1,
        speed: 1,
        speedAccuracy: 1
    );
    _pickPlacemark=Placemark(name: address);
    mapController.animateCamera(CameraUpdate.newCameraPosition
      (CameraPosition(target: LatLng(
        _pickPosition.latitude,
        _pickPosition.longitude), zoom: 17)));
    _changeAddress = false;
    _loading = false;
    update();
  }
}