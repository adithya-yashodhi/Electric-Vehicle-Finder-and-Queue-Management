import 'package:flutter/material.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/text_strings.dart';

class EVMapAppBar extends StatelessWidget {
  const EVMapAppBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return EVAppBar(title: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(EVTexts.mapAppbarTitle, style: Theme.of(context).textTheme.bodyLarge!.apply(color: EVColors.grey)),
      ],
    ),
    );
  }
}