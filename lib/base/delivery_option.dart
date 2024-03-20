import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/order_controller.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';

class DeliveryOption extends StatelessWidget {
  final String value;
  final String title;
  final int amount;
  final bool isFree;
  const DeliveryOption({super.key,
    required this.value,
    required this.title,
    required this.amount,
    required this.isFree});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderController>(builder: (controller){
      return Row(
        children: [
          SizedBox(width: Dimensions.height20),
          Radio(
            value: value,
            groupValue: controller.deliveryOption,
            activeColor: AppColors.mainColor,
            onChanged: (value) {
              controller.updateDeliveryOption(value!);
            },
          ),
          SizedBox(width: Dimensions.height10/2),
          Text(title, style: TextStyle(
              fontSize: Dimensions.font26*0.8,
              fontWeight: FontWeight.w500
          )
          ),
          SizedBox(width: Dimensions.height10/2),
          Text(isFree?" (Free)":" (\$${amount/10})",  style: TextStyle(
              fontSize: Dimensions.font26*0.8,
              fontWeight: FontWeight.w500
          )
          )
        ],
      );
    });
  }
}
