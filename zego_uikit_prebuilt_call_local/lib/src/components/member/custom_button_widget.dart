import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:zego_uikit/zego_uikit.dart';

class CustomButtonWidget extends StatelessWidget {
  var icon;
  var onPressed;

  CustomButtonWidget({
    Key? key,
    required this.icon,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size containerSize = Size(96.r, 96.r);
    Size sizeBoxSize = Size(56.r, 56.r);
    return InkWell(
      onTap: () {
        if (onPressed != null) {
          onPressed();
        }
      },
      child: Container(
        width: containerSize.width,
        height: containerSize.height,
        padding: EdgeInsets.zero,
        margin: EdgeInsets.zero,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: controlBarButtonCheckedBackgroundColor,
          borderRadius: BorderRadius.circular(containerSize.width),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox.fromSize(
              size: sizeBoxSize,
              child: icon,
            )
          ],
        ),
      ),
    );
  }
}
