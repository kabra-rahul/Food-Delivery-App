import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/widgets/small_text.dart';

import '../utils/colors.dart';
import '../utils/dimensions.dart';
import 'big_text.dart';
import 'icon_and_text_widget.dart';

class AppColumn extends StatelessWidget {
  final String text;
  const AppColumn({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start ,
      children: [
        BigText(text: text, size: Dimensions.font26),
        SizedBox(height: Dimensions.height15),
        Row(
          children: [
            Wrap(
                children: List.generate(5, (index) => Icon(Icons.star, color: AppColors.mainColor, size: Dimensions.height15))
            ),
            SizedBox(width: Dimensions.height10),
            SmallText(text: '4.5'),
            SizedBox(width: Dimensions.height10),
            SmallText(text: '600  Comments')
          ],
        ),
        SizedBox(height: Dimensions.height15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconAndTextWidget(iconData: Icons.circle_sharp,
                text: 'Normal',
                iconColor: AppColors.iconColor1),

            IconAndTextWidget(iconData: Icons.location_on,
                text: '1.7 Km',
                iconColor: AppColors.mainColor),

            IconAndTextWidget(iconData: Icons.access_time_filled_rounded,
                text: '32 Min',
                iconColor: AppColors.iconColor2)
          ],
        )
      ],
    );
  }
}
