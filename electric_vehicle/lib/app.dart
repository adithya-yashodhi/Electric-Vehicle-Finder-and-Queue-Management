import 'package:electric_vehicle/bindings/general_bindings.dart';
import 'package:electric_vehicle/utils/constants/colors.dart';
import 'package:electric_vehicle/utils/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      themeMode: ThemeMode.system,
      theme: EVAppTheme.lightTheme,
      darkTheme: EVAppTheme.darkTheme,
      initialBinding: GeneralBindings(),


      /// show loader or circular progress indicator meanwhile authentication repository is deciding to show relevant screen.
      home: const Scaffold(
        backgroundColor: EVColors.primary,
        body: Center(
        child: CircularProgressIndicator(
        color: Colors.white,
        ),
        ),
      ),

    );
  }
}
