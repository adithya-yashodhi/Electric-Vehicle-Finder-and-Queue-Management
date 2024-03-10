import 'package:electric_vehicle/features/authentication/screens/admin_station/add_station.dart';
import 'package:electric_vehicle/features/authentication/screens/admin_station/port/port_detail/add_port.dart';
import 'package:floating_action_bubble/floating_action_bubble.dart';
import 'package:flutter/material.dart';

class CircularFabButton extends StatefulWidget {
  const CircularFabButton({
    required Key key,
   }) : super(key: key);

  @override
  State<CircularFabButton> createState() => _CircularFabButtonState();
}

class _CircularFabButtonState extends State<CircularFabButton>
    with SingleTickerProviderStateMixin {
  late Animation<double> _animation;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );

    final curvedAnimation =
    CurvedAnimation(curve: Curves.easeInOut, parent: _animationController);
    _animation = Tween<double>(begin: 0, end: 1).animate(curvedAnimation);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionBubble(
        // Menu items
        items: <Bubble>[
          // Floating action menu item
          Bubble(
            title: "Add Port",
            iconColor: Colors.white,
            bubbleColor: const Color(0xff269E66),
            icon: Icons.add_circle_rounded,
            titleStyle: const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const AddPortScreen()));
              _animationController.reverse();
            },
          ),
          // Floating action menu item
            Bubble(
            title: "Add Station",
            iconColor: Colors.white,
            bubbleColor: const Color(0xff269E66),
            icon: Icons.add_circle_rounded,
            titleStyle:
            const TextStyle(fontSize: 16, color: Colors.white),
            onPress: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => const AddStationScreen()));
              _animationController.reverse();
            },
          ),
        ],
        // animation controller
        animation: _animation,
        // On pressed change animation state
        onPress: () => _animationController.isCompleted
            ? _animationController.reverse()
            : _animationController.forward(),
        // Floating Action button Icon color
        iconColor: Colors.white,
        // Flaoting Action button Icon
        iconData: Icons.add,
        backGroundColor: const Color(0xff269E66),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
