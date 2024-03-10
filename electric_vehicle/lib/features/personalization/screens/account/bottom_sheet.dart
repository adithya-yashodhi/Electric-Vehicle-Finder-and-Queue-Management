import 'package:electric_vehicle/features/personalization/screens/account/switch_account.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../utils/constants/colors.dart';

class AddAccountScreen extends StatelessWidget {
  const AddAccountScreen({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              IconButton(icon: const Icon(Iconsax.add_circle, color: EVColors.black, size: 50),
                onPressed: () {
                  Navigator.pop(context);
                showModalBottomSheet(
                context: context,
                builder: (context) =>
                  const SwitchAccountScreen());
               }
              ),
              Text('Add Account',style: Theme.of(context)
                  .textTheme
                  .titleLarge,),
            ],
          ),
        ],
      ),
    );
  }
}