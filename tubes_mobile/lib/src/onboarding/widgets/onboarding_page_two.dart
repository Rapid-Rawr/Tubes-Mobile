import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tubes_mobile/common/utils/kcolors.dart';
import 'package:tubes_mobile/common/utils/kstrings.dart';
import 'package:tubes_mobile/common/widgets/app_style.dart';
import 'package:tubes_mobile/const/resource.dart';

class OnboardingScreenTwo extends StatelessWidget {
  const OnboardingScreenTwo ({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: ScreenUtil().screenWidth,
      height: ScreenUtil().screenHeight,
      child: Stack(
        children: [
          Image.asset(
            R.ASSETS_IMAGES_WISHLIST_PNG,
            fit: BoxFit.cover,
          ),
          Positioned(
            bottom: 200,
            left: 30,
            right: 30,
            child: Text(
              AppText.kOnboardWishListMessage,
              textAlign: TextAlign.center,
              style: appStyle(11, Kolors.kGray, FontWeight.normal),
            ),
          ),
        ], 
      ),
    );
  }
}