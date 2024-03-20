import 'package:food_delivery/data/api/api_client.dart';
import 'package:food_delivery/models/signup_body_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../../utils/app_constants.dart';

class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});

  Future<Response> registration(SignUpBodyModel signUpBodyModel) async{
    Response response = await apiClient.postData(AppConstants.REGISTRATION_URI, signUpBodyModel.toJson());
    return response;
  }


  Future<String> getUserToken() async {
    return await sharedPreferences.getString(AppConstants.TOKEN)??"None";
  }


  Future<Response> login(String phone, String password) async{
    Response response = await apiClient.postData(AppConstants.LOGIN_URI, {"phone":phone,"password":password});
    return response;
  }


  Future<bool> saveUserToken(String token) async {
    apiClient.token = token;
    apiClient.updateHeader(token);

    return await sharedPreferences.setString(AppConstants.TOKEN, token);
  }


  bool userLoggedIn(){
    return sharedPreferences.containsKey(AppConstants.TOKEN);
  }


  Future<void> saveUserNumberAndPassword(String number, String password) async {
    try{
      await sharedPreferences.setString(AppConstants.PHONE, number);
      await sharedPreferences.setString(AppConstants.PASSWORD, password);
    } catch(e){
      throw e;
    }
  }


  bool clearSharedData(){
    sharedPreferences.remove(AppConstants.TOKEN);
    sharedPreferences.remove(AppConstants.PHONE);
    sharedPreferences.remove(AppConstants.PASSWORD);

    apiClient.token = "";
    apiClient.updateHeader("");

    return true;
  }
}