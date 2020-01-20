import 'dart:math';

import 'package:flutter/material.dart';

class CardText extends StatefulWidget {
  final double width;
  final double height;
  final Color color;
  final Text text;

  CardText({
    @required this.color,
    @required this.text,
    @required this.width,
    @required this.height,
  });

  @override
  _CardTextState createState() {
    return _CardTextState();
  }
}

class _CardTextState extends State<CardText>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation _animation;

  @override
  void initState() {
    super.initState();

    _animationController = new AnimationController(
        duration: Duration(milliseconds: 500), vsync: this);
    _animation = Tween(end: 1.0, begin: 0.0).animate(_animationController)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed ||
            status == AnimationStatus.dismissed) {
          _animationController.stop();
          _animationController.reset();
        }
      });
  }

  @override
  void didUpdateWidget(CardText oldWidget) {
    if (oldWidget.text.data != widget.text.data) {
      _animationController.forward();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity()
        ..setEntry(3, 2, 0.002)
        ..rotateX(pi * 2 * _animation.value),
      child: Container(
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(10),
        ),
        width: widget.width,
        height: widget.height,
        child: Center(
          child: widget.text,
        ),
      ),
    );
  }
}
