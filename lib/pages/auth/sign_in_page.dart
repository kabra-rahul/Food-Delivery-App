import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/pages/auth/sign_up_page.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

import '../../base/show_custom_snackbar.dart';
import '../../route/route_helper.dart';

class SignInPage extends StatelessWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var passController = TextEditingController();
    var phoneController = TextEditingController();


    void login(AuthController authController){
      //var authController = Get.find<AuthController>();

      String phone = phoneController.text.trim();
      String password = passController.text.trim();

      if(phone.isEmpty) {
        showCustomSnackBar("Type in your Email", title: "Email");
      }// else if(!GetUtils.isEmail(email)) {
        //showCustomSnackBar("Type in valid Email" , title: "Email");
      //}
      else if(password.isEmpty) {
        showCustomSnackBar("Type in your Password", title: "Password");
      } else if(password.length < 6) {
        showCustomSnackBar("Password is less than 6 characters", title: "Password");
      }  else {
        authController.login(phone, password).then((status){
          if(status.isSuccess){
            Get.toNamed(RouteHelper.getInitialRoute());
          } else {
            showCustomSnackBar(status.message, title: "Login Failed");
          }
        });
      }
    }


    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController) {
        return !authController.isLoading?SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimensions.screenHeight*0.05,),
              //app logo
              Container(
                height: Dimensions.screenHeight*0.25,
                child: const Center(
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 80,
                    backgroundImage: AssetImage("assets/image/logo part 1.png"),
                  ),
                ),
              ),

              //welcome
              Container(
                  margin: EdgeInsets.only(left: Dimensions.height20),
                  width: double.maxFinite,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Hello",
                        style: TextStyle(
                            fontSize: Dimensions.font20*3,
                            fontWeight: FontWeight.bold
                        ),
                      ),
                      Text("Sign into your account",
                        style: TextStyle(
                            fontSize: Dimensions.font20,
                            color: Colors.grey.shade500
                        ),
                      )
                    ],
                  )
              ),
              SizedBox(height: Dimensions.height30),
              /*Container(
              margin: EdgeInsets.only(left: Dimensions.height20),
              child: Align(alignment: Alignment.centerLeft,
                    child: BigText(text: "Sign into your account", size: Dimensions.font20 , color: Colors.grey.shade500 )
              ),
            ),*/

              AppTextField(textEditingController: phoneController, hintText: "Mobile", icon: Icons.phone),
              SizedBox(height: Dimensions.height20,),

              AppTextField(textEditingController: passController, hintText: "Password", icon: Icons.password_sharp, isPassword: true),
              SizedBox(height: Dimensions.height20,),

              Container(
                margin: EdgeInsets.only(right: Dimensions.height20),
                child: Align(
                  alignment: Alignment.centerRight,
                  child: RichText(
                    text: TextSpan(
                        text: "Sign into your account",
                        style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: Dimensions.font20
                        )),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.screenHeight*0.075),

              GestureDetector(
                onTap: (){
                  login(authController);
                },
                child: Container(
                  height: Dimensions.screenHeight/15,
                  width: Dimensions.screenWidth/2,
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(Dimensions.height30)
                  ),
                  child: Center(child: BigText(text: "Sign In", size: Dimensions.font26,color: Colors.white)),
                ),
              ),
              SizedBox(height: Dimensions.screenHeight*0.075),

              RichText(text: TextSpan(
                  text: "Don't have an account? ",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: Dimensions.font20
                  ),
                  children: [
                    TextSpan(
                        recognizer: TapGestureRecognizer()..onTap=()=>Get.to(()=>const SignUpPage(), transition: Transition.fade),
                        text: "Create",
                        style: TextStyle(
                            color: AppColors.mainBlackColor,
                            fontSize: Dimensions.font20,
                            fontWeight: FontWeight.bold
                        )
                    )
                  ]
              )
              ),
            ],
          ),
        ):const CustomLoader();
      }),
    );
  }
}
