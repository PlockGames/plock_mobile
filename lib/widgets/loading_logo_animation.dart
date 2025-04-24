import 'package:flutter/material.dart';

class LoadingLogoAnimation extends StatefulWidget {
  final double size;

  const LoadingLogoAnimation({Key? key, this.size = 80.0}) : super(key: key);

  @override
  State<LoadingLogoAnimation> createState() => _LoadingLogoAnimationState();
}

class _LoadingLogoAnimationState extends State<LoadingLogoAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    )..repeat(reverse: true); // Fait pulser l'animation

    _opacityAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Image.asset(
          'assets/images/app_logo.png',
          width: widget.size,
          height: widget.size,
        ),
      ),
    );
  }
}
