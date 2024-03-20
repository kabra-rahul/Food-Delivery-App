import 'package:flutter/cupertino.dart';
import 'package:food_delivery/widgets/small_text.dart';

import '../utils/dimensions.dart';

class IconAndTextWidget extends StatelessWidget {

  final IconData iconData;
  final String text;
  final Color iconColor;

  const IconAndTextWidget({Key? key,
    required this.iconData ,
    required this.text ,
    required this.iconColor
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(iconData, color: iconColor, size: Dimensions.Icon24),
        const SizedBox(width: 5),
        SmallText(text: text)
      ],
    );
  }
}
