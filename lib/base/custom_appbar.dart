import 'package:flutter/material.dart';
import 'package:food_delivery/route/route_helper.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/widgets/big_text.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget{
  final String title;
  final bool backButtonExist;
  final Function? onBackPressed;

  const CustomAppBar({super.key, required this.title, this.backButtonExist=true, this.onBackPressed});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: BigText(text: title, color: Colors.white),
      centerTitle: true,
      elevation: 0,
      backgroundColor: AppColors.mainColor,
      leading: backButtonExist?
      IconButton(
          onPressed: ()=>onBackPressed!=null?onBackPressed!():Navigator.pushReplacementNamed(context, RouteHelper.initial),
          icon: const Icon(Icons.arrow_back_ios)):const SizedBox(),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size(500,50);
}
