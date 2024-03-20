import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery/utils/colors.dart';
import 'package:food_delivery/utils/dimensions.dart';
import 'package:food_delivery/widgets/small_text.dart';

class ExpandableTextWidget extends StatefulWidget {
  final String text;

  const ExpandableTextWidget({Key? key, required this.text}) : super(key: key);

  @override
  State<ExpandableTextWidget> createState() => _ExpandableTextWidgetState();
}

class _ExpandableTextWidgetState extends State<ExpandableTextWidget> {
  late String firstHalf;
  late String secondHalf;

  bool hiddenText=true;

  double textHeight = Dimensions.screenHeight/5.68;

  @override
  void initState() {
    super.initState();

    if(widget.text.length > textHeight) {
      firstHalf  = widget.text.substring(0,textHeight.toInt());
      secondHalf = widget.text.substring(textHeight.toInt() + 1, widget.text.length);
    }
    else {
      firstHalf  = widget.text;
      secondHalf = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: secondHalf.isEmpty?SmallText(text: firstHalf , size: Dimensions.font16,color: AppColors.paraColor):Column(
        children: [
          SmallText(text: hiddenText?("$firstHalf..."):(firstHalf+secondHalf), size: Dimensions.font16, color: AppColors.paraColor),
          InkWell(
            onTap: (){
              setState(() {
                hiddenText = !hiddenText;
              });
            },
            child: Row(
              children: [
                SmallText(text: hiddenText?('Show More'):('Show Less'), color : AppColors.mainColor, size: Dimensions.font16),
                Icon(hiddenText?(Icons.keyboard_arrow_down):(Icons.keyboard_arrow_up),color : AppColors.mainColor, size: Dimensions.font16),
              ],
            ),
          )
        ],
      ),
    );
  }
}
