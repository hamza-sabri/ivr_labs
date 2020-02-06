import 'package:flutter/material.dart';

class EasInBackAnimation extends StatefulWidget {
  final double begin, end;
  final int duration;
  final Curve customAnimation;
  final Widget child;

  const EasInBackAnimation({
    Key key,
    @required this.begin,
    @required this.end,
    @required this.duration,
    @required this.customAnimation,
    @required this.child,
  }) : super(key: key);

  @override
  _EasInBackAnimationState createState() => _EasInBackAnimationState();
}

class _EasInBackAnimationState extends State<EasInBackAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;
  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this,
        duration: Duration(
          milliseconds: widget.duration,
        ));
    _animation =
        Tween(begin: widget.begin, end: widget.end).animate(CurvedAnimation(
      parent: _animationController,
      curve: widget.customAnimation,
    ));

    _animationController.forward();
  }

  @override
  void dispose() {
    // _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double width = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform(
          transform:
              Matrix4.translationValues(_animation.value * width, 0.0, 0.0),
          child: widget.child,
        );
      },
    );
  }
}
