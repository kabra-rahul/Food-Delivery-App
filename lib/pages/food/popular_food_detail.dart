import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/cart_controller.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_column.dart';
import 'package:food_delivery/widgets/app_icon.dart';
import 'package:food_delivery/widgets/expandable_text_widget.dart';
import 'package:get/get.dart';

import '../../widgets/big_text.dart';

class PopularFoodDetail extends StatelessWidget {
  final int pageId;
  final String page;

  PopularFoodDetail({required this.pageId, required this.page ,Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var product = Get.find<PopularProductController>().popularProductList[pageId];
    // to run the initProduct function to initialize the counter to zero
    Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          //background image
          Positioned(
              left: 0,
              right: 0,
              child: Container(
                 width: double.maxFinite,
                 height: Dimensions.popularfood,
                 decoration: BoxDecoration(
                   image: DecorationImage(
                     fit: BoxFit.cover,
                     image: NetworkImage(AppConstants.BASE_URL+AppConstants.UPLOADS+product.img)
                   )
                 )
          )),
          //Icons
          Positioned(
              left: Dimensions.height20,
              right: Dimensions.height20,
              top: Dimensions.height45,
              child: Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [ 
                         GestureDetector(
                             onTap: (){
                               if(page == 'cartpage') {
                                 Get.toNamed(RouteHelper.getCartPage());
                               }
                               else {
                                 Get.toNamed(RouteHelper.getInitialRoute());
                               }
                             },
                             child: AppIcon(iconData:  Icons.arrow_back_ios)),
                          GetBuilder<PopularProductController>(builder: (controller) {
                            return GestureDetector(
                              onTap: () {
                                Get.toNamed(RouteHelper.getCartPage());
                              },
                              child: Stack(
                                children: [
                                  AppIcon(iconData: Icons.shopping_cart_outlined),
                                  controller.totalItems>=1?
                                  Positioned(
                                      right:0, top:0,
                                      child: AppIcon(iconData: Icons.circle,size:20 ,iconColor: Colors.transparent ,backgroundColor: AppColors.mainColor,)):
                                    Container(),
                                  controller.totalItems>=1?
                                  Positioned(
                                      right:5, top:3,
                                      child: BigText(text: controller.totalItems.toString(), size: 12, color: Colors.white,)):
                                  Container()
                                ],
                              ),
                            );
                         }),
                         //
                       ],
          )
          ),
          // About The Food
          Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              top: Dimensions.popularfood-20,
              child: Container(
                padding: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20, top: Dimensions.height20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(Dimensions.height20),
                    topRight: Radius.circular(Dimensions.height20)
                  ),
                  color: Colors.white
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AppColumn(text: product.name!),
                    SizedBox(height: Dimensions.height45),
                    BigText(text: 'Details '),
                    SizedBox(height: Dimensions.height20),
                    //expandable text widget
                    Expanded(child: SingleChildScrollView(child: ExpandableTextWidget(text: product.description!)))
                  ],
                )

          )),
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (popularProduct) {
        return Container(
          height: Dimensions.pageViewTextContainer,
          padding: EdgeInsets.all(Dimensions.height20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(Dimensions.height30),
                  topRight: Radius.circular(Dimensions.height30)
              ),
              color: AppColors.buttonBackgroundColor
          ),
          child: Row(
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
                    Padding(
                      padding: EdgeInsets.all(Dimensions.height20),
                      child: GestureDetector(
                          onTap: () {
                            popularProduct.setQuantity(false);
                          },
                          child: Icon(Icons.remove, color: AppColors.signColor,)),
                    ),
                    BigText(text: popularProduct.inCartItems.toString()),
                    Padding(
                      padding: EdgeInsets.all(Dimensions.height20),
                      child: GestureDetector(
                          onTap: () {
                            popularProduct.setQuantity(true);
                          },
                          child: Icon(Icons.add, color: AppColors.signColor,)),
                    ),
                  ],
                ),
              ),
              TextButton(
                  onPressed: () {
                    popularProduct.addItem(product);
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: AppColors.mainColor,
                    padding: EdgeInsets.all(Dimensions.height20),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(Dimensions.height20)
                    )
                ),
                  child:  BigText(text: "\$ ${product.price}  | Add To Cart"),
              )
            ],
          ),
        );
      }
      )
    );
  }
}
