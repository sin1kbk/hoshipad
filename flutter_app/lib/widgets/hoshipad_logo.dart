import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HoshipadLogo extends StatefulWidget {
  final double size;

  const HoshipadLogo({super.key, this.size = 40});

  @override
  State<HoshipadLogo> createState() => _HoshipadLogoState();
}

class _HoshipadLogoState extends State<HoshipadLogo> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );

    _rotateAnimation = Tween<double>(begin: -0.5, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.elasticOut,
      ),
    );

    _controller.forward();
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
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value * 3.14159,
            child: child,
          ),
        );
      },
      child: Container(
        width: widget.size,
        height: widget.size,
        decoration: BoxDecoration(
          color: const Color(0xFFFF7400),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            // White star in top half
            Positioned(
              top: widget.size * 0.01,
              child: Icon(
                Icons.star_rounded,
                color: Colors.white,
                size: widget.size * 0.7,
              ),
            ),
            // Crossed cutlery SVG in bottom half (larger)
            Positioned(
              top: widget.size * 0.45,
              child: SvgPicture.asset(
                'assets/icons/crossed_cutlery.svg',
                width: widget.size * 0.7,
                height: widget.size * 0.7,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

