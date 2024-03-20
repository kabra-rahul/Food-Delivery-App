import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_appbar.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/location_controller.dart';
import 'package:food_delivery/controllers/user_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/account_widget.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    bool _userLoggedIn = Get.find<AuthController>().userLoggedIn();

    if(_userLoggedIn) {
      Get.find<UserController>().getUserInfo();
      Get.find<LocationController>().getAddressList();
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Profile', backButtonExist: false),
      body: GetBuilder<UserController>(builder: (userController) {
            return _userLoggedIn?(userController.isLoading? Container(
              width: double.maxFinite,
              margin: EdgeInsets.only(top: Dimensions.height20),
              child: Column(
                children: [
                  AppIcon(iconData: Icons.person,
                    backgroundColor: AppColors.mainColor,
                    iconColor: Colors.white,
                    size: Dimensions.height15*12,
                    iconSize: Dimensions.height15*6,),
                  SizedBox(height: Dimensions.height20,),
                  Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            AccountWidget(
                                appIcon: AppIcon(iconData: Icons.person,
                                    backgroundColor: AppColors.mainColor,
                                    iconColor: Colors.white,
                                    size: Dimensions.height10*5,
                                    iconSize: Dimensions.height10*5/2),
                                bigText: BigText(text: userController.userModel!.name)),
                            AccountWidget(
                                appIcon: AppIcon(iconData: Icons.phone,
                                    backgroundColor: AppColors.yellowColor,
                                    iconColor: Colors.white,
                                    size: Dimensions.height10*5,
                                    iconSize: Dimensions.height10*5/2),
                                bigText: BigText(text: userController.userModel!.phone)),
                            AccountWidget(
                                appIcon: AppIcon(iconData: Icons.email,
                                    backgroundColor: AppColors.yellowColor,
                                    iconColor: Colors.white,
                                    size: Dimensions.height10*5,
                                    iconSize: Dimensions.height10*5/2),
                                bigText: BigText(text: userController.userModel!.email)),
                            GetBuilder<LocationController>(builder: (locationController) {
                              return GestureDetector(
                                onTap: (){
                                  Get.offNamed(RouteHelper.getAddAddressPage());
                                },
                                child: AccountWidget(
                                    appIcon: AppIcon(iconData: Icons.location_on,
                                        backgroundColor: AppColors.yellowColor,
                                        iconColor: Colors.white,
                                        size: Dimensions.height10*5,
                                        iconSize: Dimensions.height10*5/2),
                                    bigText: BigText(text: locationController.addressList.isEmpty?"Add Address":"Edit Address")),
                              );
                            }),
                            AccountWidget(
                                appIcon: AppIcon(iconData: Icons.message,
                                    backgroundColor: Colors.redAccent,
                                    iconColor: Colors.white,
                                    size: Dimensions.height10*5,
                                    iconSize: Dimensions.height10*5/2),
                                bigText: BigText(text: "Messages")),
                            GestureDetector(
                              onTap: (){
                                if (Get.find<AuthController>().userLoggedIn())
                                {
                                  Get.find<AuthController>().clearSharedData();
                                  Get.find<CartController>().clear();
                                  Get.find<CartController>().clearCartHistory();
                                  Get.find<LocationController>().clearAddressList();
                                  Get.toNamed(RouteHelper.getSignInPage());
                                }
                                else {
                                  Get.toNamed(RouteHelper.getSignInPage());
                                }
                              },
                              child: AccountWidget(
                                  appIcon: AppIcon(iconData: Icons.logout,
                                      backgroundColor: Colors.redAccent,
                                      iconColor: Colors.white,
                                      size: Dimensions.height10*5,
                                      iconSize: Dimensions.height10*5/2),
                                  bigText: BigText(text: "Logout")),
                            ),
                          ],
                        ),
                      )),
                ],
              ),
            ): const CustomLoader()):
            Container(
                child: Center(
                  child: GestureDetector(
                    onTap: (){
                      Get.offNamed(RouteHelper.getSignInPage());
                    },
                    child: Text("You Must Login"))));
      } ),
    );
  }
}
