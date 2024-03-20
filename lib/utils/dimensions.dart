import 'package:get/get.dart';

class Dimensions {

  static double screenHeight = Get.context!.height; // use Getx package  and GetMaterialApp in main file to get the dimensions
  static double screenWidth  = Get.context!.width;

  static double pageView = screenHeight/2.67;
  static double pageViewContainer = screenHeight/3.87;
  static double pageViewTextContainer = screenHeight/7.11;

  static double height45 = screenHeight/18.95;
  static double height30 = screenHeight/28.42;
  static double height20 = screenHeight/42.63;
  static double height15 = screenHeight/56.84;
  static double height10 = screenHeight/85.4;

  static double font20 = screenHeight/42.63;
  static double font26 = screenHeight/32.8;
  static double font12 = screenHeight/71.05;
  static double font16 = screenHeight/53.28;

  //For Icon
  static double Icon24 = screenHeight/35.52;
  static double Icon16 = screenHeight/53.29;

  //Popular Food Image
  static double popularfood = screenHeight/2.44;
}