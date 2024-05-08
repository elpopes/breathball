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
  Timer? _timer; // Timer to manage the overall duration
  Timer? _updateTimer; // Timer to update the cycle duration

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this, // The vsync anchor is still needed
      duration: Duration(seconds: 10) // Start with a 10-second cycle
    );

    setupAnimation(); // Setup initial animation

    // Periodically update the cycle duration
    _updateTimer = Timer.periodic(Duration(seconds: 60), (Timer t) {
      int minutes = t.tick; // Every tick is a minute
      int newDuration = 10 + (50 * minutes ~/ 15); // Linearly increase from 10 to 60 seconds over 15 minutes
      if (newDuration > 60) {
        newDuration = 60; // Cap the duration at 60 seconds
      }
      _controller.duration = Duration(seconds: newDuration); // Update the controller's duration
      setupAnimation(); // Resetup the animation with the new duration
    });

    // Timer to stop the animation after 15 minutes
    _timer = Timer(const Duration(minutes: 15), () {
      _controller.stop(); // Stops the animation
      _updateTimer?.cancel(); // Stop the periodic timer as well
      setState(() {
        _breathingText = 'Session Complete'; // Optionally update the text to indicate completion
      });
    });

    _controller.repeat(); // Start the animation
  }

  void setupAnimation() {
    _animation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 300.0, end: 600.0),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 600.0, end: 300.0),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: ConstantTween<double>(300.0),
        weight: 25,
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
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
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    _updateTimer?.cancel();
    super.dispose();
  }
}
