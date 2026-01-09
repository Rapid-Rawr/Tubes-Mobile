import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tubes_mobile/common/utils/kcolors.dart';
import 'package:tubes_mobile/common/utils/kstrings.dart';
import 'package:tubes_mobile/common/widgets/app_style.dart';
import 'package:tubes_mobile/const/resource.dart';


class OnboardingScreenOne extends StatelessWidget {
  const OnboardingScreenOne({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      child: Stack(
        children: [
          Image.asset(
            R.ASSETS_IMAGES_EXPERIENCE_PNG,
            fit: BoxFit.cover,
          ), // Image.asset
          Positioned(
            bottom: 200,
            left: 30,
            right: 30,
            child: Text(
              AppText.kOnboardHome,
              textAlign: TextAlign.center,
              style: appStyle(11, Kolors.kGray, FontWeight.normal),
            ),
          ),
        ], 
      ),
    );
  }
}
