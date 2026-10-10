import 'package:flutter/material.dart';

class AnimatedChatBadge extends StatefulWidget {
  final bool show;
  final Widget child;

  const AnimatedChatBadge({
    super.key,
    required this.show,
    required this.child,
  });

  @override
  State<AnimatedChatBadge> createState() =>
      _AnimatedChatBadgeState();
}

class _AnimatedChatBadgeState
    extends State<AnimatedChatBadge>
    with SingleTickerProviderStateMixin {
  late final AnimationController
  _controller;

  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 900,
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 1.18,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.show) {
      _controller.repeat(
        reverse: true,
      );
    }
  }

  @override
  void didUpdateWidget(
      covariant AnimatedChatBadge oldWidget,
      ) {
    super.didUpdateWidget(oldWidget);

    if (widget.show && !oldWidget.show) {
      _controller.repeat(
        reverse: true,
      );
    }

    if (!widget.show && oldWidget.show) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.show) {
      return widget.child;
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        widget.child,

        Positioned(
          right: -6,
          top: -5,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
              child: const Center(
                child: Text(
                  '1',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}