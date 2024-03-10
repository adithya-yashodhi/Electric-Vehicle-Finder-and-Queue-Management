import 'package:flutter/material.dart';
import '../../../../utils/constants/colors.dart';
import '../curved_edges/curved_edges_widget.dart';
import 'circular_container.dart';

class EVPrimaryHeaderContainer extends StatelessWidget {
  const EVPrimaryHeaderContainer({
    super.key, required this.child,
  });

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return EVCurvedEdgeWidget(
      child: Container(
        color: EVColors.primary,

        padding: const EdgeInsets.only(bottom: 0),

          child: Stack(
            children: [
              /// -- background custom shapes
              Positioned(
                  top: -150, right: -250, child: EVCircularContainer(backgroundColor: EVColors.textWhite.withOpacity(0.1))),
              Positioned(
                  top: 100, right: -300, child: EVCircularContainer(backgroundColor: EVColors.textWhite.withOpacity(0.1))),
              child,
            ],
          ),
      ),
    );
  }
}