import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/controllers/popular_product_controller.dart';
import 'package:food_delivery/controllers/recommended_product_controller.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/app_constants.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/app_column.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:food_delivery/widgets/small_text.dart';
import 'package:get/get.dart';
import '../../models/product_model.dart';
import '../../utils/dimensions.dart';



class FoodPageBody extends StatefulWidget {
  const FoodPageBody({Key? key}) : super(key: key);

  @override
  State<FoodPageBody> createState() => _FoodPageBodyState();
}

class _FoodPageBodyState extends State<FoodPageBody> {
  PageController pageController = PageController(viewportFraction: 0.80);

  var _currPageValue = 0.0;
  double scaleFactor = 0.8;
  double _height = Dimensions.pageViewContainer;

  @override
  void initState() {
    super.initState();

    pageController.addListener(() {
      setState(() {
        _currPageValue = pageController.page!;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    pageController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //slider section
        //getbuilder connects popularproductcontroller to the UI
        //if you want to get updated data and redraw UI then you should wrap UI with getbuilder and related controller
        // builder : (popularProducts) is an instance of the related controller
        GetBuilder<PopularProductController>(builder: (popularProducts){
          return popularProducts.isLoaded? Container(
              height: Dimensions.pageView,
              child: PageView.builder(
                    controller: pageController,
                    //popularProductList is the public list from the controller file
                    itemCount: popularProducts.popularProductList.length,
                    itemBuilder: (context, index){
                      return _buildPageItem(index,popularProducts.popularProductList[index]);
                    }),

          ):const CircularProgressIndicator();
        }),
    //Dots
    GetBuilder<PopularProductController>(builder: (popularProducts){
      return DotsIndicator(
        dotsCount: popularProducts.popularProductList.isEmpty?1:popularProducts.popularProductList.length,
        position: _currPageValue.toInt(),
        decorator: DotsDecorator(
          activeColor: AppColors.mainColor,
          size: const Size.square(9.0),
          activeSize: const Size(18.0, 9.0),
          activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5.0)),
        ),
      );
    }),
        //Popular text
        SizedBox(height: Dimensions.height30,),
        Container(
          margin: EdgeInsets.only(left: Dimensions.height30),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              BigText(text: 'Recommended'),
              SizedBox(width: Dimensions.height10,),
              BigText(text: '.', color: Colors.black26,),
              SizedBox(width: Dimensions.height20,),
              SmallText(text: 'Food pairing'),
            ],
          ),
        ),
        // List of food images
        //Recommended Food
        GetBuilder<RecommendedProductController>(builder: (recommendedProducts){
          return recommendedProducts.isLoaded? ListView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: recommendedProducts.recommendedProductList.length,
              itemBuilder: (context,index) {
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(RouteHelper.getRecommendedFood(index,'home'));
                  },
                  child: Container (
                    margin: EdgeInsets.only(bottom: Dimensions.height10, left: Dimensions.height20,right: Dimensions.height20),
                    child: Row(
                      children: [
                        //image
                        Container(
                          width: 120,
                          height: 120,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(Dimensions.height20),
                              color: Colors.white38,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage("${AppConstants.BASE_URL}/uploads/${recommendedProducts.recommendedProductList[index].img}")
                              )
                          ),
                        ),
                        //Details
                        Expanded(
                            child: Container(
                              height: 100,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(Dimensions.height20),
                                      bottomRight: Radius.circular(Dimensions.height20)
                                  ),
                                  color: Colors.white
                              ),
                              child: Padding(
                                padding: EdgeInsets.only(left: Dimensions.height10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    BigText(text: recommendedProducts.recommendedProductList[index].name),
                                    SmallText(text: 'recommendedProducts.recommendedProductList[index].description'),
                                    Row(
                                      children: [
                                        Wrap(
                                            children: List.generate(recommendedProducts.recommendedProductList.length, (index) => Icon(Icons.star, color: AppColors.mainColor, size: Dimensions.height15))
                                        ),
                                        SizedBox(width: Dimensions.height10),
                                        SmallText(text: '4.5'),
                                        SizedBox(width: Dimensions.height10),
                                        SmallText(text: '600  Comments')
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ))
                      ],
                    ),
                  ),
                );
              }):CircularProgressIndicator(color: AppColors.mainColor,);
        }),

      ],
    );
  }

  Widget _buildPageItem( int index, ProductModel popularProduct ) {

    Matrix4 matrix = Matrix4.identity();

    if( index == _currPageValue.floor()) {
        var currScale = 1 - (_currPageValue-index)*(1- scaleFactor);
        var currTrans = _height*(1-currScale)/2;
        matrix = Matrix4.diagonal3Values(1 , currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }
    else if( index == _currPageValue.floor()+1) {
      var currScale = scaleFactor + (_currPageValue-index+1)*(1- scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1 , currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }
    else if( index == _currPageValue.floor()-1) {
      var currScale = 1 - (_currPageValue-index)*(1- scaleFactor);
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1 , currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }
    else {
      var currScale = 0.8;
      var currTrans = _height*(1-currScale)/2;
      matrix = Matrix4.diagonal3Values(1 , currScale, 1)..setTranslationRaw(0, currTrans, 0);
    }

    return Transform(
      transform: matrix,
      child: Stack(
        children: [
          GestureDetector(
            onTap: ()=> Get.toNamed(RouteHelper.getPopularFood(index,'initial')),
            child: Container(
               height: _height,
               margin: EdgeInsets.only(right: Dimensions.height15,left: Dimensions.height15),
               decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: AppColors.yellowColor,
                  image : DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage("${AppConstants.BASE_URL}/uploads/${popularProduct.img!}")
                 )
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: Dimensions.pageViewTextContainer,
              margin: EdgeInsets.only(right: Dimensions.height30,left: Dimensions.height30,bottom: Dimensions.height30),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0xFFE8E8E8),
                      blurRadius: 5.0,
                      offset: Offset(0,5)
                    ),
                    BoxShadow(
                      color: Colors.white,
                        offset: Offset(-5,0)
                    ),
                    BoxShadow(
                        color: Colors.white,
                        offset: Offset(5,0)
                    )
                  ],
              ),
              child: Container(
                padding: EdgeInsets.only(left: Dimensions.height15, top: Dimensions.height10, right: Dimensions.height15),
                child: AppColumn(text: popularProduct.name!),
              ),
            ),
          ),
        ]
      ),
    );
  }
}
