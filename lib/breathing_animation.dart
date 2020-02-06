import 'package:flutter/material.dart';

class BreathingAnimation extends StatefulWidget {
  final Widget myChild;
  final width, height;
  BreathingAnimation({@required this.myChild, this.width, this.height});
  @override
  _BreathingAnimationState createState() => _BreathingAnimationState();
}

class _BreathingAnimationState extends State<BreathingAnimation>
    with TickerProviderStateMixin {
  AnimationController rippleController;

  Animation<double> rippleAnimation;

  @override
  void initState() {
    super.initState();

    rippleController = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );

    rippleAnimation = Tween<double>(
      begin: 95.0,
      end: 99.0,
    ).animate(rippleController)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          rippleController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          rippleController.forward();
        }
      });

    rippleController.forward();
  }

  @override
  void dispose() {
    rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _animation(widget.myChild);
  }

  _animation(myChild) {
    return AnimatedBuilder(
      animation: rippleAnimation,
      builder: (context, child) => Container(
          width: rippleAnimation.value + widget.width - 90,
          height: rippleAnimation.value + widget.height - 90,
          child: myChild),
    );
  }
}
