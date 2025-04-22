import 'package:argil_tiles/app_const/app_color.dart';
import 'package:argil_tiles/app_const/app_size.dart';
import 'package:argil_tiles/utils/text_style_helper/text_style_helper.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class PrimaryBtn extends StatelessWidget {
  const PrimaryBtn(
      {super.key,
      this.height,
      this.width,
      this.backGroundColor,
      this.borderRadius,
      required this.btnText,
      this.textStyle,
      required this.onTap,
      this.borderColor,
      this.borderWidth});
  final double? width;
  final double? height;
  final Color? backGroundColor;
  final BorderRadiusGeometry? borderRadius;
  final String btnText;
  final TextStyle? textStyle;
  final void Function()? onTap;
  final Color? borderColor;
  final double? borderWidth;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? 80.w,
      height: height ?? 6.h,
      child: MaterialButton(
        onPressed: onTap,
        elevation: 0,
        color: backGroundColor ?? AppColors.primaryColor,
        shape: RoundedRectangleBorder(
            side: BorderSide(
                color: borderColor ?? AppColors.primaryColor,
                width: borderWidth ?? 1),
            borderRadius:
                borderRadius ?? BorderRadius.circular(AppSize.size10)),
        child: Text(
          btnText,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textStyle ??
              TextStyleHelper.smallHeading
                  .copyWith(color: AppColors.whiteColor),
        ),
      ),
    );
  }

}
