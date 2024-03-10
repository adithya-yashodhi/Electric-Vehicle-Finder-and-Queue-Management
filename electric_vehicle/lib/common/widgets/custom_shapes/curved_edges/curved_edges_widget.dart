import 'package:flutter/material.dart';

import 'curved_edges.dart';

class EVCurvedEdgeWidget extends StatelessWidget {
  const EVCurvedEdgeWidget({
    super.key, this.child,
  });

  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: EVCustomCurvedEdges(),
      child: child,
    );
  }
}