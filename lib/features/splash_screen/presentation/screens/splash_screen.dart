import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:notification_services_android_ios/core/utils/constants/app_sizer.dart';
import '../../../../core/common/widgets/custom_text.dart';
import '../../../../core/utils/constants/app_colors.dart';
import '../../../../core/utils/constants/app_sizes.dart';
import '../../../../core/utils/constants/image_path.dart';
import '../../controllers/splash_controller.dart';

class SplashScreen extends GetView<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffDEF7F8),
      body: Stack(
        children: [
          // Top logo background
          Positioned(
            top: 153,
            left: 35,
            right: 35,
            child: Row(
              children: [
                Image.asset(
                  ImagePath.appLogo,
                  height: 90.h,
                  fit: BoxFit.contain,
                ),
                SizedBox(width: getWidth(10)),
                Expanded(
                  child: CustomText(
                    text: 'Push Notification Android & iOS',
                    textAlign: TextAlign.center,
                    fontSize: 22.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),

          // Bottom splashBacOne image
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Image.asset(
              ImagePath.splashBacOne,
              height: 460.h,
              fit: BoxFit.cover,
            ),
          ),

          // Middle splash background image
          Positioned(
            left: 29.w,
            right: 29.w,
            bottom: 122.h,
            child: SizedBox(
              height: 385.h,
              child: Image.asset(
                ImagePath.notificationImage,
                fit: BoxFit.contain,
              ),
            ),
          ),

          Positioned(
            bottom: 50,
            left: 0,
            right: 0,
            child: Center(
              child: SpinKitCircle(
                size: 60,
                color: AppColors.primaryBackground,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
