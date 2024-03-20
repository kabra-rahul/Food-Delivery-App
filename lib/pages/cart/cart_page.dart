import 'package:flutter/material.dart';
import 'package:food_delivery/base/delivery_option.dart';
import 'package:food_delivery/base/no_data_page.dart';
import 'package:food_delivery/base/payment_option_button.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/order_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/models/place_order_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../controllers/location_controller.dart';
import '../../controllers/popular_product_controller.dart';
import '../../route/route_helper.dart';
import '../../utils/app_constants.dart';
import '../../widgets/app_icon.dart';
import '../../widgets/big_text.dart';


class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController noteController = TextEditingController();
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
              top: Dimensions.height20*3,
              left: Dimensions.height20,
              right: Dimensions.height20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppIcon(iconData: Icons.arrow_back_ios,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.Icon24),
                  GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getInitialRoute());
                    },
                    child: AppIcon(iconData: Icons.home_outlined,
                        iconColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        iconSize: Dimensions.Icon24),
                  ),
                  AppIcon(iconData: Icons.shopping_cart_outlined,
                      iconColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      iconSize: Dimensions.Icon24)
                ]
              )),
          Positioned(
              top: Dimensions.height20*5,
              left: Dimensions.height20,
              right: Dimensions.height20,
              bottom: 0,
              child: Container(
                //color: Colors.lightBlue,
                margin: EdgeInsets.only(top: Dimensions.height20),
                child: MediaQuery.removePadding( // To remove automatic Padding on top of ListView
                  context: context,
                  removeTop: true,
                  child: GetBuilder<CartController>(builder: (cartController){
                    var _cartList = cartController.getItems;
                     return _cartList.isNotEmpty ?ListView.builder(
                         itemCount: _cartList.length,
                         itemBuilder: (_, index) {
                           return Container(
                               height: Dimensions.height20*5,
                               width:double.maxFinite,
                               child: Row(
                                 children: [
                                   GestureDetector(
                                     onTap: (){
                                     var popularIndex = Get.find<PopularProductController>()
                                                           .popularProductList
                                                           .indexOf(_cartList[index].product);

                                     if( popularIndex >= 0) {
                                       Get.toNamed(RouteHelper.getPopularFood(popularIndex,"cartpage"));
                                     } else {
                                       var recommendedIndex = Get.find<RecommendedProductController>()
                                           .recommendedProductList
                                           .indexOf(_cartList[index].product);
                                       
                                       if (recommendedIndex <0) {
                                         Get.snackbar("History Product", "Product review is not available",
                                         backgroundColor: AppColors.mainColor,
                                         colorText: Colors.white);
                                       }
                                       else {
                                         Get.toNamed(RouteHelper.getRecommendedFood(recommendedIndex,"cartpage"));
                                       }
                                     }
                                     },
                                     child: Container(
                                       height: Dimensions.height20*5,
                                       width: Dimensions.height20*5,
                                       margin: EdgeInsets.only(bottom: Dimensions.height10),
                                       decoration: BoxDecoration(
                                           image: DecorationImage(
                                               fit: BoxFit.cover,
                                               image: NetworkImage(AppConstants.BASE_URL + AppConstants.UPLOADS  +  _cartList[index].img!)
                                           ),
                                           borderRadius: BorderRadius.circular(Dimensions.height20),
                                           color: Colors.white
                                       ),
                                     ),
                                   ),
                                   Expanded(child: Container(
                                     height: Dimensions.height20*5,
                                     //color: Colors.green,
                                     child: Padding(
                                       padding: EdgeInsets.only(left: Dimensions.height15),
                                       child: Column(
                                         crossAxisAlignment: CrossAxisAlignment.start,
                                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                         children: [
                                           BigText(text: _cartList[index].name!, color: Colors.black54,),
                                           SmallText(text: 'Spicy'),
                                           Row(
                                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                             children: [
                                               BigText(text: '\$${_cartList[index].price!*_cartList[index].quantity!}', color: Colors.redAccent,),
                                               Row(
                                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                 children: [
                                                   Padding(
                                                     padding: EdgeInsets.all(Dimensions.height10),
                                                     child: GestureDetector(
                                                         onTap: () {
                                                           cartController.addItem(_cartList[index].product!, -1);
                                                         },
                                                         child: Icon(Icons.remove, color: AppColors.signColor,)),
                                                   ),
                                                   BigText(text: _cartList[index].quantity!.toString()),
                                                   Padding(
                                                     padding: EdgeInsets.all(Dimensions.height10),
                                                     child: GestureDetector(
                                                         onTap: () {
                                                           cartController.addItem(_cartList[index].product!, 1);
                                                         },
                                                         child: Icon(Icons.add, color: AppColors.signColor,)),
                                                   ),
                                                 ],
                                               )
                                             ],
                                           )
                                         ],
                                       ),
                                     ),
                                   )
                                   )
                                 ],
                               )
                           );
                         }):const NoDataPage(text: "Your Cart is Empty!");
                  }
                  ),
                )
                )
              )
        ]
      ),
    bottomNavigationBar: GetBuilder<OrderController>(builder: (orderController){
      noteController.text = orderController.foodNote.trim();
      return GetBuilder<CartController>(builder: (cartController) {
        return Container(
          height: Dimensions.pageViewTextContainer*1.5,
          padding: EdgeInsets.all(Dimensions.height20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.height30),
                  topRight: Radius.circular(Dimensions.height30)
              ),
              color: AppColors.buttonBackgroundColor
          ),
          child: cartController.getItems.isNotEmpty?Column(
            children: [
              TextButton(
                  onPressed: ()=>showModalBottomSheet(
                      backgroundColor: Colors.transparent,
                      context: context,
                      builder: (_){
                        return Column(
                          children: [
                            Expanded(
                              child: SingleChildScrollView(
                                child: Container(
                                  padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
                                  //height: MediaQuery.of(context).size.height,
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(Dimensions.height20),
                                          topLeft: Radius.circular(Dimensions.height20)
                                      )
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: Dimensions.height20),
                                      const PaymentOptionButton(
                                          icon: Icons.money,
                                          title: 'Cash on Delivery',
                                          subTitle: 'Pay after receiving the delivery',
                                          index: 0),
                                      const PaymentOptionButton(
                                          icon: Icons.paypal_outlined,
                                          title: 'Digital Payment',
                                          subTitle: 'Safer and faster way of payment',
                                          index: 1),
                                      SizedBox(height: Dimensions.height10),
                                      Divider(thickness: 1,color: Theme.of(context).disabledColor),
                                      SizedBox(height: Dimensions.height10),
                                      Padding(
                                        padding: EdgeInsets.only(left: Dimensions.height20),
                                        child: BigText(text: "Delivery Option", size: Dimensions.font26),
                                      ),
                                      DeliveryOption(
                                          value: 'Home Delivery',
                                          title: 'Home Delivery',
                                          amount: cartController.totalAmount,
                                          isFree: false),
                                      const DeliveryOption(
                                          value: 'Take Away',
                                          title: 'Take Away',
                                          amount: 0,
                                          isFree: true),
                                      SizedBox(height: Dimensions.height10),
                                      Divider(thickness: 1,color: Theme.of(context).disabledColor),
                                      SizedBox(height: Dimensions.height10),
                                      SizedBox(width: Dimensions.height10),
                                      Padding(
                                        padding: EdgeInsets.only(left: Dimensions.height20),
                                        child: BigText(text: "Additional Info", size: Dimensions.font26),
                                      ),
                                      AppTextField(
                                        textEditingController: noteController,
                                        hintText: "",
                                        icon: Icons.note,
                                        maxLines: true,
                                        iconColor: AppColors.mainColor,
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          ],
                        );
                      }).whenComplete(() => orderController.updateFoodNote(noteController.text)),
                  style: TextButton.styleFrom(
                      fixedSize: Size.fromWidth(Dimensions.screenWidth-Dimensions.height45),
                      foregroundColor: Colors.white,
                      backgroundColor: AppColors.mainColor,
                      padding: EdgeInsets.all(Dimensions.height20),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(Dimensions.height20)
                      )
                  ) ,
                  child:  BigText(text: "Payment & Delivery Option",color: Colors.white,)
              ),
              SizedBox(height: Dimensions.height10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(Dimensions.height20),
                        color: Colors.white
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        //GetBuilder<PopularProductController>(builder: (controller) {
                        Padding(
                            padding: EdgeInsets.all(Dimensions.height20),
                            child: BigText(text: '\$${cartController.totalAmount}')
                        )
                        //})
                      ],
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      if(Get.find<AuthController>().userLoggedIn())
                      {
                        if(Get.find<LocationController>().addressList.isEmpty) {
                          Get.toNamed(RouteHelper.getAddAddressPage());
                        } else {
                          var location = Get.find<LocationController>().getUserAddress();
                          var user = Get.find<UserController>().userModel;
                          var cart =  cartController.getItems;
                          PlaceOrderBody placeOrder = PlaceOrderBody(
                              cart: cart,
                              orderAmount: 100,
                              distance: 10.0,
                              scheduleAt: "scheduleAt",
                              orderNote: noteController.text,
                              address: location.address,
                              latitude: location.latitude,
                              longitude: location.longitude,
                              contactPersonName: user!.name,
                              contactPersonNumber: user!.phone,
                              orderType: orderController.isOptionSelected==0?"cash_on_delivery":"digital_payment",
                              paymentMethod: orderController.deliveryOption
                          );
                          orderController.placeOrder(_callback, placeOrder);
                        }
                      } else {
                        Get.toNamed(RouteHelper.getSignInPage());
                      }
                    },
                    style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: AppColors.mainColor,
                        padding: EdgeInsets.all(Dimensions.height20),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(Dimensions.height20)
                        )
                    ) ,
                    child:  BigText(text: "Check Out", color: Colors.white,),
                  )
                ],
              )
            ],
          ):Container(),
        );
      }
      );
    })
    );
  }

  _callback(bool isSuccess, String message, String orderId) {
    if(isSuccess) {
      Get.find<CartController>().addToHistory();

      if( Get.find<OrderController>().isOptionSelected==0){
        Get.toNamed(RouteHelper.getOrderSuccessPage(orderId, "success"));
      }
      else {
        Get.toNamed(RouteHelper.getPaymentPage( orderId, Get.find<UserController>().userModel!.id));
      }

    } else {
      showCustomSnackBar(message);
    }
  }
}
