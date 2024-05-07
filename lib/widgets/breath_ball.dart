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
      duration: const Duration(seconds: 30), // Adjusted duration to fit the breathing pattern
      vsync: this,
    );

    // Define the sequence of animations
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 300.0, end: 600.0), // Inhale
        weight: 25, // Shorter duration
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 600.0, end: 300.0), // Exhale
        weight: 50, // Longer duration for exhale
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(300.0), // Hold after exhale
        weight: 25, // Duration of hold
      ),
    ]).animate(_controller)
      ..addListener(() {
        setState(() {
          double value = _controller.value;
          if (value < 0.25) {
            _breathingText = 'Breathe in';
          } else if (value < 0.75) {
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
