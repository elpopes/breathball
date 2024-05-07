import 'dart:async';
import 'package:flutter/material.dart';

class BreathBall extends StatefulWidget {
  @override
  _BreathBallState createState() => _BreathBallState();
}

class _BreathBallState extends State<BreathBall> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  String _breathingText = 'Breathe in';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4), // Duration of one breath cycle
      vsync: this,
    );

    _animation = Tween<double>(begin: 300.0, end: 600.0).animate(_controller)
      ..addListener(() {
        setState(() {
          // Update the text based on animation direction
          _breathingText = _controller.status == AnimationStatus.forward ? 'Breathe in' : 'Breathe out';
        });
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _controller.reverse();
        } else if (status == AnimationStatus.dismissed) {
          _controller.forward();
        }
      });

    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: _animation.value,
        height: _animation.value,
        decoration: BoxDecoration(
          color: Colors.blueAccent,
          shape: BoxShape.circle,
        ),
        child: Center(
          child: Text(
            _breathingText,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 24),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
