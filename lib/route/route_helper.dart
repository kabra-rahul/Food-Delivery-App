import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/pages/auth/sign_in_page.dart';
import 'package:food_delivery/pages/cart/cart_page.dart';
import 'package:food_delivery/pages/food/popular_food_detail.dart';
import 'package:food_delivery/pages/payment/payment_page.dart';
import 'package:food_delivery/pages/splash/splash_page.dart';
import 'package:get/get.dart';
import '../pages/address/add_address_page.dart';
import '../pages/address/pick_address_page.dart';
import '../pages/food/recommended_food_detail.dart';
import '../pages/home/home_page.dart';
import '../pages/payment/order_success_page.dart';


class RouteHelper {
  static const String splashPage = "/splash-page";
  static const String initial = "/";
  static const String popularFood = "/popular-food";
  static const String recommendedFood = "/recommended-food";
  static const String cartPage = "/cart-page";
  static const String signInPage = "/sign-in";
  static const String addAddressPage = "/add-address";
  static const String pickAddressPage = "/pick-address";
  static const String payment = "/payment";
  static const String orderSuccess = "/order-successful";

  static String getSplashPage()=> '$splashPage';
  static String getInitialRoute()=> '$initial';
  static String getPopularFood(int pageId, String page)=>'$popularFood?pageId=$pageId&page=$page';
  static String getRecommendedFood(int pageId, String page)=>'$recommendedFood?pageId=$pageId&page=$page';
  static String getCartPage()=>'$cartPage';
  static String getSignInPage()=>'$signInPage';
  static String getAddAddressPage()=>'$addAddressPage';
  static String getPickAddressPage()=>'$pickAddressPage';
  static String getPaymentPage(String id, int userId)=>'$payment?id=$id&userId=$userId';
  static String getOrderSuccessPage(String orderId, String status)=>'$orderSuccess?id=$orderId&status=$status';

  static List<GetPage> routes = [
    GetPage(name: splashPage,page: ()=>SplashScreen()),

    GetPage(name: initial, page: ()=> HomePage()),

    GetPage(name: signInPage, page: ()=> SignInPage(), transition: Transition.fade),

    GetPage(name: addAddressPage, page: ()=> AddAddressPage(), transition: Transition.fade),

    GetPage(name: payment, page: () {
      return PaymentPage(orderModel: OrderModel(
        id: int.parse(Get.parameters['id']!),
        userId: int.parse(Get.parameters['userId']!)
      ));
    }),

    GetPage(name: orderSuccess, page: ()=>OrderSuccessPage(
      orderId: Get.parameters['id']!,
      status:  Get.parameters['status'].toString().contains('success')?1:0
      )
    ),

    GetPage(name: pickAddressPage,
            page: () {
                       PickAddressPage _pickAddressPage = Get.arguments;
                       return _pickAddressPage;
                     },
            transition: Transition.fade
    ),

    GetPage(name: popularFood, page: () {
      var pageId = Get.parameters['pageId'];
      var page = Get.parameters['page'];
      return PopularFoodDetail(pageId: int.parse(pageId!),page: page!);
    },
     transition: Transition.fadeIn
  ),
    GetPage(name: recommendedFood, page: () {
      var pageId = Get.parameters['pageId'];
      var page = Get.parameters['page'];
      return RecommendedFoodDetail(pageId: int.parse(pageId!),page: page!);
    },
        transition: Transition.fadeIn
    ),
     GetPage(name: cartPage, page: () {
       return CartPage();
     },
       transition: Transition.fadeIn
     )

  ];
}