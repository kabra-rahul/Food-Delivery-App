import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/models/order_model.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:get/get.dart';
import '../../controllers/order_controller.dart';

class ViewOrder extends StatelessWidget {

  final bool isCurrent;

  const ViewOrder({super.key, required this.isCurrent});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<OrderController>(builder: (orderController){

        if(orderController.isLoading == false) {
          late List<OrderModel> orderList;

          if(orderController.currentOrderList.isNotEmpty || orderController.historyOrderList.isNotEmpty) {
            orderList = isCurrent?orderController.currentOrderList.reversed.toList()
                        :orderController.historyOrderList.reversed.toList();
          }

          return SizedBox(
            width: Dimensions.screenWidth,
            child: ListView.builder(
                itemCount: orderList.length,
                itemBuilder: (context, index){
              return InkWell(
                onTap: ()=>{},
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: Dimensions.height20, vertical: Dimensions.height10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Order ID  #${orderList[index].id}'),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                  width: Dimensions.screenWidth/4,
                                  padding: const EdgeInsets.all(5),
                                  decoration: BoxDecoration(
                                    border: Border.all(width: 2, color: AppColors.mainColor),
                                  ),
                                  child: Center(child: Text("${orderList[index].orderStatus}", style: TextStyle(color: AppColors.mainColor)))
                              ),
                              SizedBox(height: Dimensions.height10),
                              InkWell(
                                onTap: ()=>{},
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                      color: AppColors.mainColor,
                                     // borderRadius: BorderRadius.circular(10)
                                  ),
                                  child: Row(
                                        children: [
                                          Image.asset("assets/image/tracking.png", height: 15, width: 15, color: Colors.white,),
                                          SizedBox(width: 10),
                                          Text('Track Order', style: TextStyle(color: Colors.white))
                                        ],
                                      )
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    const Divider(height: 1,thickness: 2)
                  ],
                ),
              );
            }),
          );

        } else {
          return const CustomLoader();
        }
      }
      )
    );
  }
}
