import 'package:flutter/material.dart';

import '../../../../../../common/widgets/image_text/image_text_widgets.dart';
import '../../../../../../utils/constants/image_strings.dart';

class PortCategory extends StatelessWidget {
  const PortCategory({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: 2,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            return EVVerticalImageText(image: EVImages.type2, title: 'Type 2', onTap: (){});
          }),
    );
  }
}