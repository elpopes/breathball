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
      duration: const Duration(seconds: 10), // Adjusted for total cycle including holds
      vsync: this,
    );

    // Define the sequence of animations
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 300.0, end: 600.0), // Inhale
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(600.0), // Hold
        weight: 20.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 600.0, end: 300.0), // Exhale
        weight: 30.0,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(300.0), // Hold
        weight: 20.0,
      ),
    ]).animate(_controller)
      ..addListener(() {
        setState(() {
          // Update text based on animation phase
          if (_controller.value < 0.3) {
            _breathingText = 'Breathe in';
          } else if (_controller.value < 0.5) {
            _breathingText = 'Hold';
          } else if (_controller.value < 0.8) {
            _breathingText = 'Breathe out';
          } else {
            _breathingText = 'Hold';
          }
        });
      });

    _controller.repeat(); // Change to repeat to continuously cycle the animation
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
