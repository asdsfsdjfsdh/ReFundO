import 'package:flutter/material.dart';
import 'package:refundo/core/theme/app_theme.dart';

/// 应用动画工具类
class AppAnimations {
  AppAnimations._();

  /// 淡入过渡
  static PageRouteBuilder<T> fadeTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: CurveTween(curve: Curves.easeInOut).animate(animation),
          child: child,
        );
      },
    );
  }

  /// 滑动过渡（从右到左）
  static PageRouteBuilder<T> slideTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  /// 缩放过渡
  static PageRouteBuilder<T> scaleTransition<T>({
    required Widget page,
    Duration duration = const Duration(milliseconds: 300),
  }) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = 0.0;
        const end = 1.0;
        const curve = Curves.easeInOut;

        var tween = Tween(begin: begin, end: end).chain(
          CurveTween(curve: curve),
        );

        return ScaleTransition(
          scale: animation.drive(tween),
          child: FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
      },
    );
  }

  /// 列表项淡入动画
  static Widget listSlideFade({
    required Widget child,
    required int index,
    int? totalCount,
    Duration delay = const Duration(milliseconds: 50),
  }) {
    final itemDelay = delay * index.clamp(0, (totalCount ?? index) - 1);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 50 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

/// 应用动画Widget
class AnimatedWidgets {
  AnimatedWidgets._();

  /// 淡入动画Widget
  static Widget fadeIn({
    required Widget child,
    Duration duration = const Duration(milliseconds: 300),
    VoidCallback? onComplete,
  }) {
    return _FadeInWidget(
      duration: duration,
      onComplete: onComplete,
      child: child,
    );
  }

  /// 缩放动画Widget
  static Widget scale({
    required Widget child,
    Duration duration = const Duration(milliseconds: 200),
    VoidCallback? onTap,
  }) {
    return _ScaleWidget(
      duration: duration,
      onTap: onTap,
      child: child,
    );
  }

  /// 脉冲动画Widget
  static Widget pulse({
    required Widget child,
    Duration duration = const Duration(milliseconds: 1000),
  }) {
    return _PulseWidget(
      duration: duration,
      child: child,
    );
  }

  /// 抖动动画Widget
  static Widget shake({
    required Widget child,
    Duration duration = const Duration(milliseconds: 500),
  }) {
    return _ShakeWidget(
      duration: duration,
      child: child,
    );
  }
}

class _FadeInWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onComplete;

  const _FadeInWidget({
    required this.child,
    required this.duration,
    this.onComplete,
  });

  @override
  State<_FadeInWidget> createState() => _FadeInWidgetState();
}

class _FadeInWidgetState extends State<_FadeInWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward().then((_) {
      if (widget.onComplete != null) {
        widget.onComplete!();
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
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

class _ScaleWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final VoidCallback? onTap;

  const _ScaleWidget({
    required this.child,
    required this.duration,
    this.onTap,
  });

  @override
  State<_ScaleWidget> createState() => _ScaleWidgetState();
}

class _ScaleWidgetState extends State<_ScaleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    setState(() => _isPressed = true);
    _controller.forward();
  }

  void _handleTapUp(TapUpDetails details) {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  void _handleTapCancel() {
    setState(() => _isPressed = false);
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap,
      child: ScaleTransition(
        scale: _animation,
        child: widget.child,
      ),
    );
  }
}

class _PulseWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const _PulseWidget({
    required this.child,
    required this.duration,
  });

  @override
  State<_PulseWidget> createState() => _PulseWidgetState();
}

class _PulseWidgetState extends State<_PulseWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: _animation.value,
      child: widget.child,
    );
  }
}

class _ShakeWidget extends StatefulWidget {
  final Widget child;
  final Duration duration;

  const _ShakeWidget({
    required this.child,
    required this.duration,
  });

  @override
  State<_ShakeWidget> createState() => _ShakeWidgetState();
}

class _ShakeWidgetState extends State<_ShakeWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticIn),
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
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value * 10, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
