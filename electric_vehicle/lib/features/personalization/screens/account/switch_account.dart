import 'package:electric_vehicle/features/authentication/screens/login/user/login.dart';
import 'package:electric_vehicle/features/authentication/screens/signup/signup.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SwitchAccountScreen extends StatelessWidget {
  const SwitchAccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 250,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text('Add Account',style: Theme.of(context).textTheme.titleLarge)),
              const Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.to(() => const LoginScreen());
                      }, child: const Text('Log Into Existing Account')),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: TextButton(onPressed: () {
                  Navigator.pop(context);
                  Get.to(() => const SignupScreen());
                },
                  child: const Text('Create Account', style: TextStyle(color: Color(0xff269E66))),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
