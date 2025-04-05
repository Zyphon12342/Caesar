import 'package:flutter/material.dart';

class HorizontalOrbitLoader extends StatelessWidget {
  final double size;
  final Color color;
  final double speed;

  const HorizontalOrbitLoader({
    super.key,
    this.size = 20,
    this.color = Colors.white,
    this.speed = 2.5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size,
      width: size,
      child: Row(
        children: List.generate(
          6,
          (index) => _SliceWidget(
            size: size,
            color: color,
            speed: speed,
            index: index,
          ),
        ),
      ),
    );
  }
}

class _SliceWidget extends StatelessWidget {
  final double size;
  final Color color;
  final double speed;
  final int index;

  const _SliceWidget({
    required this.size,
    required this.color,
    required this.speed,
    required this.index,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size / 6,
      height: size,
      child: Stack(
        children: [
          // Before element
          Positioned(
            left: 0,
            top: size / 2 - size / 12,
            child: _OrbitingDot(
              size: size,
              color: color,
              speed: speed,
              delay: -(speed / 6) * index,
            ),
          ),
          // After element
          Positioned(
            left: 0,
            top: size / 2 - size / 12,
            child: _OrbitingDot(
              size: size,
              color: color,
              speed: speed,
              delay: -(speed / 2) - (speed / 6) * index,
            ),
          ),
        ],
      ),
    );
  }
}

class _OrbitingDot extends StatefulWidget {
  final double size;
  final Color color;
  final double speed;
  final double delay;

  const _OrbitingDot({
    required this.size,
    required this.color,
    required this.speed,
    required this.delay,
  });

  @override
  State<_OrbitingDot> createState() => _OrbitingDotState();
}

class _OrbitingDotState extends State<_OrbitingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (widget.speed * 1000).toInt()),
    );

    // Add delay before starting animation
    Future.delayed(Duration(milliseconds: (-widget.delay * 1000).toInt()), () {
      if (mounted) {
        _controller.repeat();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        // Calculate the current position in the orbit cycle (0.0 to 1.0)
        final t = _controller.value;

        // Apply the orbit transformation and scaling from the keyframes
        double translateY;
        double scale;
        double opacity;

        if (t < 0.05) {
          translateY =
              lerpDouble(widget.size * 0.25, widget.size * 0.235, t / 0.05);
          scale = lerpDouble(0.73684, 0.684208, t / 0.05);
          opacity = lerpDouble(0.65, 0.58, t / 0.05);
        } else if (t < 0.1) {
          translateY = lerpDouble(
              widget.size * 0.235, widget.size * 0.182, (t - 0.05) / 0.05);
          scale = lerpDouble(0.684208, 0.631576, (t - 0.05) / 0.05);
          opacity = lerpDouble(0.58, 0.51, (t - 0.05) / 0.05);
        } else if (t < 0.15) {
          translateY = lerpDouble(
              widget.size * 0.182, widget.size * 0.129, (t - 0.1) / 0.05);
          scale = lerpDouble(0.631576, 0.578944, (t - 0.1) / 0.05);
          opacity = lerpDouble(0.51, 0.44, (t - 0.1) / 0.05);
        } else if (t < 0.2) {
          translateY = lerpDouble(
              widget.size * 0.129, widget.size * 0.076, (t - 0.15) / 0.05);
          scale = lerpDouble(0.578944, 0.526312, (t - 0.15) / 0.05);
          opacity = lerpDouble(0.44, 0.37, (t - 0.15) / 0.05);
        } else if (t < 0.25) {
          translateY = lerpDouble(widget.size * 0.076, 0, (t - 0.2) / 0.05);
          scale = lerpDouble(0.526312, 0.47368, (t - 0.2) / 0.05);
          opacity = lerpDouble(0.37, 0.3, (t - 0.2) / 0.05);
        } else if (t < 0.3) {
          translateY = lerpDouble(0, widget.size * -0.076, (t - 0.25) / 0.05);
          scale = lerpDouble(0.47368, 0.526312, (t - 0.25) / 0.05);
          opacity = lerpDouble(0.3, 0.37, (t - 0.25) / 0.05);
        } else if (t < 0.35) {
          translateY = lerpDouble(
              widget.size * -0.076, widget.size * -0.129, (t - 0.3) / 0.05);
          scale = lerpDouble(0.526312, 0.578944, (t - 0.3) / 0.05);
          opacity = lerpDouble(0.37, 0.44, (t - 0.3) / 0.05);
        } else if (t < 0.4) {
          translateY = lerpDouble(
              widget.size * -0.129, widget.size * -0.182, (t - 0.35) / 0.05);
          scale = lerpDouble(0.578944, 0.631576, (t - 0.35) / 0.05);
          opacity = lerpDouble(0.44, 0.51, (t - 0.35) / 0.05);
        } else if (t < 0.45) {
          translateY = lerpDouble(
              widget.size * -0.182, widget.size * -0.235, (t - 0.4) / 0.05);
          scale = lerpDouble(0.631576, 0.684208, (t - 0.4) / 0.05);
          opacity = lerpDouble(0.51, 0.58, (t - 0.4) / 0.05);
        } else if (t < 0.5) {
          translateY = lerpDouble(
              widget.size * -0.235, widget.size * -0.25, (t - 0.45) / 0.05);
          scale = lerpDouble(0.684208, 0.73684, (t - 0.45) / 0.05);
          opacity = lerpDouble(0.58, 0.65, (t - 0.45) / 0.05);
        } else if (t < 0.55) {
          translateY = lerpDouble(
              widget.size * -0.25, widget.size * -0.235, (t - 0.5) / 0.05);
          scale = lerpDouble(0.73684, 0.789472, (t - 0.5) / 0.05);
          opacity = lerpDouble(0.65, 0.72, (t - 0.5) / 0.05);
        } else if (t < 0.6) {
          translateY = lerpDouble(
              widget.size * -0.235, widget.size * -0.182, (t - 0.55) / 0.05);
          scale = lerpDouble(0.789472, 0.842104, (t - 0.55) / 0.05);
          opacity = lerpDouble(0.72, 0.79, (t - 0.55) / 0.05);
        } else if (t < 0.65) {
          translateY = lerpDouble(
              widget.size * -0.182, widget.size * -0.129, (t - 0.6) / 0.05);
          scale = lerpDouble(0.842104, 0.894736, (t - 0.6) / 0.05);
          opacity = lerpDouble(0.79, 0.86, (t - 0.6) / 0.05);
        } else if (t < 0.7) {
          translateY = lerpDouble(
              widget.size * -0.129, widget.size * -0.076, (t - 0.65) / 0.05);
          scale = lerpDouble(0.894736, 0.947368, (t - 0.65) / 0.05);
          opacity = lerpDouble(0.86, 0.93, (t - 0.65) / 0.05);
        } else if (t < 0.75) {
          translateY = lerpDouble(widget.size * -0.076, 0, (t - 0.7) / 0.05);
          scale = lerpDouble(0.947368, 1, (t - 0.7) / 0.05);
          opacity = lerpDouble(0.93, 1, (t - 0.7) / 0.05);
        } else if (t < 0.8) {
          translateY = lerpDouble(0, widget.size * 0.076, (t - 0.75) / 0.05);
          scale = lerpDouble(1, 0.947368, (t - 0.75) / 0.05);
          opacity = lerpDouble(1, 0.93, (t - 0.75) / 0.05);
        } else if (t < 0.85) {
          translateY = lerpDouble(
              widget.size * 0.076, widget.size * 0.129, (t - 0.8) / 0.05);
          scale = lerpDouble(0.947368, 0.894736, (t - 0.8) / 0.05);
          opacity = lerpDouble(0.93, 0.86, (t - 0.8) / 0.05);
        } else if (t < 0.9) {
          translateY = lerpDouble(
              widget.size * 0.129, widget.size * 0.182, (t - 0.85) / 0.05);
          scale = lerpDouble(0.894736, 0.842104, (t - 0.85) / 0.05);
          opacity = lerpDouble(0.86, 0.79, (t - 0.85) / 0.05);
        } else if (t < 0.95) {
          translateY = lerpDouble(
              widget.size * 0.182, widget.size * 0.235, (t - 0.9) / 0.05);
          scale = lerpDouble(0.842104, 0.789472, (t - 0.9) / 0.05);
          opacity = lerpDouble(0.79, 0.72, (t - 0.9) / 0.05);
        } else {
          translateY = lerpDouble(
              widget.size * 0.235, widget.size * 0.25, (t - 0.95) / 0.05);
          scale = lerpDouble(0.789472, 0.73684, (t - 0.95) / 0.05);
          opacity = lerpDouble(0.72, 0.65, (t - 0.95) / 0.05);
        }

        return Transform.translate(
          offset: Offset(0, translateY),
          child: Transform.scale(
            scale: scale,
            child: Opacity(
              opacity: opacity,
              child: Container(
                height: widget.size / 6,
                width: widget.size / 6,
                decoration: BoxDecoration(
                  color: widget.color,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// Helper function to linearly interpolate between two doubles
double lerpDouble(double a, double b, double t) {
  return a + (b - a) * t;
}
