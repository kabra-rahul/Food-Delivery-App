import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/order_controller.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class PaymentOptionButton extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subTitle;
  final int index;
  const PaymentOptionButton({super.key,
  required this.icon,
  required this.title,
  required this.subTitle,
  required this.index});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (controller){
      Color selectedColor = controller.isOptionSelected==index?AppColors.mainColor:Theme.of(context).disabledColor;
      return InkWell(
        onTap: (){
          controller.updatePaymentOption(index);
        },
        child: Container(
          margin: EdgeInsets.only(left: Dimensions.height30, top: Dimensions.height10, right: Dimensions.height30 ),
          decoration: BoxDecoration(
              border: Border.all(
                  width: 2,
                  color: selectedColor
              )
          ),
          child: ListTile(
            leading: Icon(
              icon,
              size: 40,
              color: selectedColor,
            ),
            title: Text(title ,
                style: TextStyle(
                    fontSize: Dimensions.font26,
                    fontWeight: FontWeight.bold
                )
            ),
            subtitle: Text(subTitle),
            trailing: controller.isOptionSelected==index?Icon(Icons.check_circle_rounded, color: selectedColor):null,
          ),
        ),
      );
    });
  }
}
