import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:tubes_mobile/common/utils/kcolors.dart';
import 'package:tubes_mobile/common/utils/kstrings.dart';
import 'package:tubes_mobile/common/widgets/app_style.dart';
import 'package:tubes_mobile/common/widgets/custom_button.dart';
import 'package:tubes_mobile/common/widgets/reusable_text.dart';
import 'package:tubes_mobile/const/resource.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Kolors.kWhite,
        width: ScreenUtil().screenWidth,
        height: ScreenUtil().screenHeight,
        child: Column(
          children: [
            SizedBox(
              height: 100.h,
            ),
            Image.asset(R.ASSETS_IMAGES_GETSTARTED_PNG),
            SizedBox(
              height: 30.h,
            ),
            Text(
              AppText.kWelcomeHeader,
              textAlign: TextAlign.center,
              style: appStyle(24, Kolors.kPrimary, FontWeight.bold),
            ), // Text
            SizedBox(
              height: 20.h,
            ), // SizedBox
            SizedBox(
              width: ScreenUtil().screenWidth - 100,
              child: Text(
                AppText.kWelcomeMessage,
                textAlign: TextAlign.center,
                style: appStyle(11, Kolors.kGray, FontWeight.normal),
              ), // Text
            ), // SizedBox
            SizedBox(
              height: 20.h,
            ), // SizedBox
            SizedBox(
              width: ScreenUtil().screenWidth - 100,
              child: Text(
                AppText.kWelcomeMessage,
                textAlign: TextAlign.center,
                style: appStyle(11, Kolors.kGray, FontWeight.normal),
              ), // Text
            ), // SizedBox
            SizedBox(
              height: 20.h,
            ), // SizedBox
            GradientBtn(
              text: AppText.kGetStarted,
              btnHieght: 35,
              radius: 20,
              btnWidth: ScreenUtil().screenWidth - 100,
              onTap: () {
                // TODO: uncomment the bool storage when the app is ready
                // Storage().setBool('firstOpen', true);
                context.go('/home');
              },
            ),

            SizedBox(
              height: 20.h,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ReusableText(text: "Already have an account?", style: appStyle(12, Kolors.kDark, FontWeight.normal)),
              
              TextButton(onPressed: () {
                //Navigate to Login Page
                context.go('/login');
              }, 
              child: const Text("Sign In", style: TextStyle(fontSize: 12, color: Colors.blue),))

              ],
            )
          ],
        ),
      ),
    ); // Container
  }
}
