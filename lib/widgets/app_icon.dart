import 'package:flutter/cupertino.dart';
import 'package:food_delivery/utils/dimensions.dart';

class AppIcon extends StatelessWidget {

  final IconData iconData;
  final Color backgroundColor;
  final Color iconColor;
  final double size;
  final double iconSize;

  AppIcon({Key? key,
  required this.iconData,
  this.backgroundColor=const Color(0xFFFCF4E4),
  this.iconColor=const Color(0xFF756D54),
  this.size=40,
  this.iconSize=16
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size/2),
        color: backgroundColor.withOpacity(0.9)
      ),
      child: Icon(iconData, color: iconColor, size:iconSize)
    );
  }
}
