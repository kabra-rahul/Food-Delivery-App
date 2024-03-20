import 'dart:convert';

import 'package:food_delivery/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/cart_model.dart';

class CartRepo {

  final SharedPreferences sharedPreferences;

  CartRepo({required this.sharedPreferences});

  List<String> cart = [];
  List<String> cartHistory = [];

  // add item to local storage
  void addToCartList(List<CartModel> cartList){
    //sharedPreferences.remove(AppConstants.CART_LIST);
    //sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
    var time = DateTime.now().toString();
    cart = [];
    //Converts objects to Strings because SharedPreferences only accepts string
    cartList.forEach((element) {
      element.time = time;
      return cart.add(jsonEncode(element));

      // below code has same meaning as above code
      //carts.forEach((element)=>cart.add(jsonEncode(element)));
    });
    
    sharedPreferences.setStringList(AppConstants.CART_LIST, cart);
    //print(sharedPreferences.getStringList(AppConstants.CART_LIST));
  }


  // retrieve item from local storage
  List<CartModel> getCartList(){

    List<String> carts=[];

    if (sharedPreferences.containsKey(AppConstants.CART_LIST)){
      carts = sharedPreferences.getStringList(AppConstants.CART_LIST)!;
    }
    List<CartModel> cartList = [];

    carts.forEach((element) {
      cartList.add(CartModel.fromJson(jsonDecode(element)));
    });
      // below code has same meaning as above code
    //carts.forEach((element)=>cartList.add(CartModel.fromJson(jsonDecode(element))));

    //print("inside getCartList "+ carts.toString());

    return cartList;
  }


  List<CartModel> getCartHistoryList(){

    if (sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)){
      cartHistory = [];
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }
    List<CartModel> cartHistoryList=[];

    cartHistory.forEach((element) {
      cartHistoryList.add(CartModel.fromJson(jsonDecode(element)));
    });
    // below code has same meaning as above code
    //carts.forEach((element)=>cartHistoryList.add(CartModel.fromJson(jsonDecode(element))));

    return cartHistoryList;
  }

  void addToCartHistoryList(){
    if(sharedPreferences.containsKey(AppConstants.CART_HISTORY_LIST)) {
      cartHistory = sharedPreferences.getStringList(AppConstants.CART_HISTORY_LIST)!;
    }

    for(int i=0; i<cart.length; i++) {
      cartHistory.add(cart[i]);
    }
    removeCart();
    sharedPreferences.setStringList(AppConstants.CART_HISTORY_LIST, cartHistory);
    print("The lenght of Cart History is : "+getCartHistoryList().length.toString());

  }


  void removeCart(){
    cart=[];
    sharedPreferences.remove(AppConstants.CART_LIST);
  }


  void clearCartHistory(){
    removeCart();
    cartHistory = [];
    sharedPreferences.remove(AppConstants.CART_HISTORY_LIST);
  }
}