import 'package:get/get.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';

import '../../controllers/popular_product_controller.dart';
import '../../controllers/recommended_product_controller.dart';
import '../../utils/dimensions.dart';
import 'food_page_body.dart';

class MainFoodPage extends StatefulWidget {
  const MainFoodPage({Key? key}) : super(key: key);

  @override
  _MainFoodPageState createState() => _MainFoodPageState();
}

Future<void> _loadResources() async {
  // To load all the data from the controller
  await Get.find<PopularProductController>().getPopularProductList();
  await Get.find<RecommendedProductController>().getRecommendedProductList();
}

class _MainFoodPageState extends State<MainFoodPage> {
  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
        child: Column(
      children: [
        Container(
            child: Container(
                margin: EdgeInsets.only(top:Dimensions.height45 ,bottom: Dimensions.height20),
                padding: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
                child :Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        BigText(text: 'India',color: AppColors.mainColor, size: Dimensions.height30,),
                        Row(
                          children: [
                            SmallText(text: 'Mumbai', color: Colors.black54,),
                            Icon(Icons.arrow_drop_down_rounded)
                          ],
                        ),
                      ],
                    ),
                    Center(
                      child: Container(
                        width: Dimensions.height45,
                        height: Dimensions.height45,
                        child: Icon(Icons.search, color: Colors.white, size: Dimensions.Icon24),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(Dimensions.height15),
                          color: AppColors.mainColor,
                        ),
                      ),
                    )
                  ],
                )
            )
        ),
        Expanded(
            child: SingleChildScrollView(
                child: FoodPageBody()))
      ],
    ),
        onRefresh: _loadResources);
  }
}
