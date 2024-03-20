import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_button.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class OrderSuccessPage extends StatelessWidget {
  final String orderId;
  final int status;
  const OrderSuccessPage({Key? key, required this.orderId, required this.status}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    if(status == 0) {
      Future.delayed(Duration(seconds: 1),() {

      });
    }
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: Dimensions.screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(status==1 ? Icons.check_circle_outline:Icons.warning_amber_outlined,
                  size: 100, color: AppColors.mainColor),
              /*Image.asset(status == 1 ? "assets/image/checked.png" : "assets/image/warning.png",
                  width: 100, height: 100, ),*/
              SizedBox(height: Dimensions.height30),
              Text( status == 1 ? "You Placed Your Order Successfully" : "Your Order Failed",
              style: TextStyle(fontSize: Dimensions.font20),
              ),
              SizedBox(height: Dimensions.height20),
              Padding(padding: EdgeInsets.symmetric(horizontal: Dimensions.height20,
                 vertical: Dimensions.height10),
              child: Text( status == 1 ? "Successful Order" : "Failed Order",
                style: TextStyle(fontSize: Dimensions.font20,
                  color: Theme.of(context).disabledColor),
                textAlign: TextAlign.center,
                )
              ),
              SizedBox(height: Dimensions.height10),
              Padding(padding: EdgeInsets.all(Dimensions.height20),
                child: CustomButton(
                  buttonText: "Back To Home",
                  onPressed: ()=> Get.offNamed(RouteHelper.getInitialRoute()),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
