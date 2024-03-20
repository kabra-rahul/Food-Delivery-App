import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/base/custom_loader.dart';
import 'package:food_delivery/base/show_custom_snackbar.dart';
import 'package:food_delivery/controllers/auth_controller.dart';
import 'package:food_delivery/models/signup_body_model.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/app_text_field.dart';
import 'package:food_delivery/widgets/big_text.dart';
import 'package:get/get.dart';

class SignUpPage extends StatelessWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    var emailController = TextEditingController();
    var passController = TextEditingController();
    var nameController = TextEditingController();
    var phoneController = TextEditingController();
    var signUpImages = ["g.png","f.png","t.png"];

    void _registration(AuthController authController){
      //var authController = Get.find<AuthController>();

      String name  = nameController.text.trim();
      String email = emailController.text.trim();
      String phone = phoneController.text.trim();
      String password = passController.text.trim();

      if(email.isEmpty) {
        showCustomSnackBar("Type in your Email", title: "Email");
      } else if(!GetUtils.isEmail(email)) {
        showCustomSnackBar("Type in valid Email" , title: "Email");
      } else if(password.isEmpty) {
        showCustomSnackBar("Type in your Password", title: "Password");
      } else if(password.length < 6) {
        showCustomSnackBar("Password is less than 6 characters", title: "Password");
      } else if(name.isEmpty) {
        showCustomSnackBar("Type in your Name", title: "Name");
      } else if(phone.isEmpty) {
        showCustomSnackBar("Type in your Mobile Number", title: "Mobile Number");
      } else {
        SignUpBodyModel signUpBodyModel = SignUpBodyModel(email: email, password: password, name: name, phone: phone);

        authController.registration(signUpBodyModel).then((status){
          if(status.isSuccess){
            Get.offNamed(RouteHelper.getInitialRoute());
          } else {
            showCustomSnackBar(status.message, title: "Registration Failed");
          }
        });
      }
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: GetBuilder<AuthController>(builder: (authController){
        return !authController.isLoading?SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              SizedBox(height: Dimensions.screenHeight*0.05,),
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
              AppTextField(textEditingController: emailController, hintText: "Email", icon: Icons.email),
              SizedBox(height: Dimensions.height20,),

              AppTextField(textEditingController: passController, hintText: "Password", icon: Icons.password_sharp,isPassword: true),
              SizedBox(height: Dimensions.height20,),

              AppTextField(textEditingController: nameController, hintText: "Name", icon: Icons.person),
              SizedBox(height: Dimensions.height20,),

              AppTextField(textEditingController: phoneController, hintText: "Mobile", icon: Icons.phone),
              SizedBox(height: Dimensions.height20 + Dimensions.height20,),

              GestureDetector(
                onTap: (){
                  _registration(authController);
                },
                child: Container(
                  height: Dimensions.screenHeight/15,
                  width: Dimensions.screenWidth/2,
                  decoration: BoxDecoration(
                      color: AppColors.mainColor,
                      borderRadius: BorderRadius.circular(Dimensions.height30)
                  ),
                  child: Center(child: BigText(text: "Sign Up", size: Dimensions.font26,color: Colors.white)),
                ),
              ),
              SizedBox(height: Dimensions.height10),

              RichText(text: TextSpan(
                  text: "Already Have an Account ?",
                  recognizer: TapGestureRecognizer()..onTap=()=>Get.toNamed(RouteHelper.getSignInPage()),
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: Dimensions.font20
                  ))),
              SizedBox(height: Dimensions.screenHeight*0.05),

              RichText(text: TextSpan(
                  text: "Sign Up using one of the following methods",
                  style: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: Dimensions.font16
                  ))),

              Wrap(
                children: List.generate(3, (index) => Padding(
                  padding: const EdgeInsets.all(15),
                  child: CircleAvatar(
                    radius: Dimensions.height30,
                    backgroundImage: AssetImage(
                        "assets/image/${signUpImages[index]}"
                    ),
                  ),
                )),
              )
            ],
          ),
        ):const CustomLoader();
      })
    );
  }
}
