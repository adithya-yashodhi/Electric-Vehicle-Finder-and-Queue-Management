import 'package:flutter/material.dart';
import '../../../../../common/widgets/image_text/image_text_widgets.dart';

class EVVehicleCategory extends StatelessWidget {
  const EVVehicleCategory({
    super.key, required this.onItemClicked, required this.images,
  });

  final Function(String) onItemClicked;
  final List<String> images;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 190,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: images.length,
          scrollDirection: Axis.horizontal,
          itemBuilder: (_, index) {
            String imageName = images[index].split('/').last.split('.').first;
            return GestureDetector(
                onTap: () {
              onItemClicked(imageName); // Call the callback with the title
            },
                child: EVVerticalImageText(image: images[index], title: imageName));
          }),
    );
  }
}