import 'dart:math';

import 'package:flutter/material.dart';

class MovingCardWidget extends StatefulWidget {
  const MovingCardWidget(
      {Key? key, required this.urlFront, required this.urlBack})
      : super(key: key);

  final String urlFront;
  final String urlBack;

  @override
  _MovingCardWidgetState createState() => _MovingCardWidgetState();
}

class _MovingCardWidgetState extends State<MovingCardWidget>
    with TickerProviderStateMixin {
  bool isFront = true;
  double verticalDrag = 0;
  late AnimationController controller;
  late Animation<double> animation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: (details) {
        controller.reset();
        setState(() {
          isFront = true;
          verticalDrag = 0;
        });
      },
      onVerticalDragUpdate: (details) {
        setState(() {
          verticalDrag += details.delta.dy;
          verticalDrag %= 360;
          setImageSide();
        });
      },
      onVerticalDragEnd: (details) {
        final double end = 360 - verticalDrag >= 180 ? 0 : 360;
        animation =
            Tween<double>(begin: verticalDrag, end: end).animate(controller)
              ..addListener(() {
                setState(() {
                  verticalDrag = animation.value;
                  setImageSide();
                });
              });
        controller.forward();
      },
      child: Transform(
        transform: Matrix4.identity()
          ..setEntry(3, 2, 0.001)
          ..rotateX(verticalDrag / 180 * pi),
        alignment: Alignment.center,
        child: isFront
            ? Image.asset(widget.urlFront)
            : Transform(
                transform: Matrix4.identity()..rotateX(pi),
                alignment: Alignment.center,
                child: Image.asset(widget.urlBack),
              ),
      ),
    );
  }

  void setImageSide() {
    if (verticalDrag <= 90 || verticalDrag >= 270) {
      isFront = true;
    } else {
      isFront = false;
    }
  }
}
