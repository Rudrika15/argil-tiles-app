import 'package:argil_tiles/app_const/app_color.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';
import 'package:toastification/toastification.dart';

mixin WidgetHelper {
  // custom sizedBox for height
  SizedBox height(double height) {
    return SizedBox(height: height);
  }

  // custom sizedBox for width
  SizedBox width(double width) {
    return SizedBox(width: width);
  }

  // default pin put theme
  // PinTheme defaultPinTheme(BuildContext context) {
  //   return PinTheme(
  //     width: 12.w,
  //     height: 14.w,
  //     margin: EdgeInsets.symmetric(horizontal: 0.5.w),
  //     textStyle:
  //         TextStyleHelper.largeHeading.copyWith(color: AppColors.primaryColor),
  //     decoration: BoxDecoration(
  //         border: Border.all(color: AppColors.primaryColor),
  //         borderRadius: BorderRadius.circular(10),
  //         color: AppColors.primaryLightColor.withOpacity(0.5)),
  //   );
  // }

  // bottom sheet divider
  SizedBox customBottomSheetDivider() {
    return SizedBox(width: 9.w, child: Divider(thickness: 0.5.h));
  }

  // show dialog
  static customSnackBar({
    required BuildContext context,
    required String title,
    Color? color,
    bool? isError,
  }) {
    if (isError ?? false) {
      // toastification;
      toastification.dismissAll();
      toastification.show(
        borderSide: BorderSide(color: color ?? Color(0xFF000000)),
        primaryColor: color,
        foregroundColor: AppColors.whiteColor,
        // backgroundColor: AppColors.errorColor,
        // primaryColor: ColorHelper.kPrimary,
        closeButtonShowType: CloseButtonShowType.none,
        type: ToastificationType.error,
        showProgressBar: false,
        alignment: Alignment.bottomCenter,
        style: ToastificationStyle.fillColored,
        dragToClose: true,
        context: context, // optional if you use ToastificationWrapper
        title: Text(title, style: TextStyle(color: AppColors.whiteColor)),
        autoCloseDuration: const Duration(seconds: 2),
      );
    } else {
      toastification.dismissAll();

      toastification.show(
        primaryColor: color,
        foregroundColor: AppColors.whiteColor,
        backgroundColor: AppColors.whiteColor,
        closeButtonShowType: CloseButtonShowType.none,
        type: ToastificationType.success,
        style: ToastificationStyle.fillColored,
        showProgressBar: false,
        alignment: Alignment.bottomCenter,
        context: context, // optional if you use ToastificationWrapper
        title: Text(title),
        autoCloseDuration: const Duration(seconds: 2),
      );
    }
  }
}
