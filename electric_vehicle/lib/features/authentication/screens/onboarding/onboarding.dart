import 'package:electric_vehicle/features/authentication/screens/onboarding/widgets/onboarding_dot_navigation.dart';
import 'package:electric_vehicle/features/authentication/screens/onboarding/widgets/onboarding_next_button.dart';
import 'package:electric_vehicle/features/authentication/screens/onboarding/widgets/onboarding_page.dart';
import 'package:electric_vehicle/features/authentication/screens/onboarding/widgets/onboarding_skip.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context){
    final controller = Get.put(OnBoardingController());

    return Scaffold(
      body: Stack(
        children: [
          // horizontal scrollable pages
          PageView(
            controller: controller.pageController,
            onPageChanged: controller.updatePageIndicator,
            children: const [
              OnBoardingPage(
                image: EVImages.onBoardingImage1,
                title: EVTexts.onBoardingTitle1,
                subTitle: EVTexts.onBoardingSubTitle1,
              ),
              OnBoardingPage(
                image: EVImages.onBoardingImage2,
                title: EVTexts.onBoardingTitle2,
                subTitle: EVTexts.onBoardingSubTitle2,
              ),
              OnBoardingPage(
                image: EVImages.onBoardingImage3,
                title: EVTexts.onBoardingTitle3,
                subTitle: EVTexts.onBoardingSubTitle3,
              ),
            ],
          ),

          //skip navigation smoothPageIndicator
          const OnBoardingSkip(),

          // dot navigation smoothPageIndicator
          const onBoardingDotNavigation(),

          // circular button
          const OnBoardingNextButton(),
        ],
      ),
    );
  }
}







