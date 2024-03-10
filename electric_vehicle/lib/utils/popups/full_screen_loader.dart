import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../common/widgets/loader/animation_loader.dart';

class EVFullScreenLoader {
  static void openLoadingDialog(String text, String animation) {
    showDialog(
        context: Get.overlayContext!, // use Get.overlayContext for overlay dialogs
        barrierDismissible: false, // the dialog can't dismissed by tapping outside it
        builder: (_) => PopScope(
          canPop: false, // disable popping with the back button
            child: Container(
              color: EVHelperFunctions.isDarkMode(Get.context!) ? EVColors.dark : EVColors.white,
              width: double.infinity,
              height: double.infinity,
              child: Column(
                children: [
                  const SizedBox(height: 250) ,// adjust the spacing
                  EVAnimationLoaderWidget(text: text, animation: animation),
                ],
              ),
            ),
        ),
    );
  }

  /// stop the current open loading dialog
  /// this method doesn't return anything
  static stopLoading() {
    Navigator.of(Get.overlayContext!).pop(); // close the dialog using the Navigator
  }
}