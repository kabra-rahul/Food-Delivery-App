import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/expandable_text_widget.dart';
import 'package:get/get.dart';
import '../../controllers/cart_controller.dart';
import '../../utils/app_constants.dart';
import '../../widgets/app_icon.dart';
import '../cart/cart_page.dart';

class RecommendedFoodDetail extends StatelessWidget {
  final int pageId;
  final String page;

  const RecommendedFoodDetail({required this.pageId, required this.page ,Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var product = Get.find<RecommendedProductController>().recommendedProductList[pageId];
    // to run the initProduct function to initialize the counter to zero
    Get.find<PopularProductController>().initProduct(product, Get.find<CartController>());
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        slivers: [
          SliverAppBar(
            //to remove back arrow
            automaticallyImplyLeading: false,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GestureDetector(
                    onTap: () {
                      if(page == 'cartpage') {
                        Get.toNamed(RouteHelper.getCartPage());
                      }
                      else {
                        Get.toNamed(RouteHelper.getInitialRoute());
                      }
                    },
                    child: AppIcon(iconData:  Icons.clear)),
                GetBuilder<PopularProductController>(builder: (controller) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed(RouteHelper.getCartPage());
                    },
                    child: Stack(
                      children: [
                        AppIcon(iconData: Icons.shopping_cart_outlined),
                        Get.find<PopularProductController>().totalItems>=1?
                        Positioned(
                            right:0, top:0,
                            child: AppIcon(iconData: Icons.circle,size:20 ,iconColor: Colors.transparent ,backgroundColor: AppColors.mainColor,)):
                        Container(),
                        Get.find<PopularProductController>().totalItems>=1?
                        Positioned(
                            right:5, top:3,
                            child: BigText(text: Get.find<PopularProductController>().totalItems.toString(), size: 12, color: Colors.white,)):
                        Container()
                      ],
                    ),
                  );
                })
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(40) ,
              child: Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    color: Colors.white,
                  ),
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: Center(child: BigText(text: product.name!)))
            ),
            pinned: true,
            backgroundColor: AppColors.yellowColor,
            expandedHeight: 300.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(AppConstants.BASE_URL+AppConstants.UPLOADS+product.img!,
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child:Column(
              children: [
                Container(
                  margin: EdgeInsets.only(left: Dimensions.height20, right:Dimensions.height20, top: Dimensions.height20 ),
                  child: (
                    ExpandableTextWidget(text: product.description!)
                  ),
                ),
              ],
            )
          )
        ],
      ),
      bottomNavigationBar: GetBuilder<PopularProductController>(builder: (controller){
         return  Column(
           mainAxisSize: MainAxisSize.min,
           children: [
             Container(
               padding: EdgeInsets.only(top: Dimensions.height10, bottom: Dimensions.height10),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   GestureDetector(
                       onTap: (){
                         controller.setQuantity(false);
                       },
                       child: AppIcon(iconData: Icons.remove, backgroundColor: AppColors.mainColor, iconColor: Colors.white,iconSize: Dimensions.Icon24)),
                   BigText(text: '\$ ${product.price}  X  ${controller.inCartItems} ', color: AppColors.mainBlackColor, size: Dimensions.font26),
                   GestureDetector(
                       onTap: (){
                          controller.setQuantity(true);
                       },
                       child: AppIcon(iconData: Icons.add, backgroundColor: AppColors.mainColor, iconColor: Colors.white,iconSize: Dimensions.Icon24))
                 ],
               ),
             ),
             Container(
               //height: Dimensions.pageViewTextContainer,
               padding: EdgeInsets.all(Dimensions.height20),
               decoration: BoxDecoration(
                   borderRadius: BorderRadius.only(
                       topLeft: Radius.circular(Dimensions.height30),
                       topRight: Radius.circular(Dimensions.height30)
                   ),
                   color: AppColors.buttonBackgroundColor
               ),
               child: Row(
                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                 children: [
                   Container(
                       decoration: BoxDecoration(
                           borderRadius: BorderRadius.circular(Dimensions.height20),
                           color: Colors.white
                       ),
                       child: Padding(
                         padding: const EdgeInsets.all(20.0),
                         child: Icon(Icons.favorite,color: AppColors.mainColor),
                       )
                   ),
                   TextButton(
                     onPressed: () {
                       controller.addItem(product);
                   },
                     child: BigText(text: '\$' + (product.price!*controller.inCartItems).toString() + ' | Add To Cart',),
                     style: TextButton.styleFrom(
                         foregroundColor: Colors.white,
                         backgroundColor: AppColors.mainColor,
                         padding: EdgeInsets.all(Dimensions.height20),
                         shape: RoundedRectangleBorder(
                             borderRadius: BorderRadius.circular(Dimensions.height20)
                         )
                     ),
                   )
                 ],
               ),
             )
           ],
         );
      }),
    );
  }
}
