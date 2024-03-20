import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController textEditingController;
  final String hintText;
  final IconData icon;
  bool isPassword;
  bool maxLines;
  Color iconColor;
  AppTextField({Key? key,
     required this.textEditingController,
     required this.hintText,
     required this.icon,
     this.isPassword=false,
     this.maxLines=false,
     this.iconColor=const Color(0xFFffd379)}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: Dimensions.height20, right: Dimensions.height20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Dimensions.height15),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 10,
                spreadRadius: 7,
                offset: const Offset(1,10),
                color: Colors.grey.withOpacity(0.2)
            )
          ]
      ),
      child: TextField(
        maxLines: maxLines?3:1,
        controller: textEditingController,
        decoration: InputDecoration(
          //hint
          hintText: hintText,
          // prefix icon
          prefixIcon: Icon(icon,color: iconColor),
          // focused border
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.height15),
              borderSide: const BorderSide(
                  width: 1.0,
                  color: Colors.white
              )
          ),
          // enabled border
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.height15),
              borderSide: const BorderSide(
                  width: 1.0,
                  color: Colors.white
              )
          ),
          // border
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.height15)
          ),
        ),
        obscureText: isPassword ,
      ),
    );
  }
}
