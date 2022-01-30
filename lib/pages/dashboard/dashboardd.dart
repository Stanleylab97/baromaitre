import 'package:flutter/material.dart';

class Dashboard extends StatefulWidget {
  Dashboard(
      {Key? key,
      required this.isCollapsed,
      required this.scaleAnimation,
      required this.screenWidth,
      required this.child,
      required this.onMenuTap})
      : super(key: key);
  bool isCollapsed = true;
  final double screenWidth;
  final Animation<double> scaleAnimation;
  final VoidCallback onMenuTap;
  final Widget child;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      top: 0,
      bottom: 0,
      left: widget.isCollapsed ? 0 : 0.6 * widget.screenWidth,
      right: widget.isCollapsed ? 0 : -0.2 * widget.screenWidth,
      duration: Duration(milliseconds: 300),
      child: ScaleTransition(
        scale: widget.scaleAnimation,
        child: Material(
          animationDuration: Duration(milliseconds: 300),
          borderRadius: BorderRadius.all(Radius.circular(40)),
          elevation: 8,
          child: widget.child,
        ),
      ),
    );
  }
}
