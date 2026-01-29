import 'package:flutter/material.dart';

/// 骨架屏加载组件
/// 提供优雅的加载状态展示
class SkeletonLoadingWidget extends StatelessWidget {
  final int itemCount;
  final double height;

  const SkeletonLoadingWidget({
    Key? key,
    this.itemCount = 5,
    this.height = 80,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      padding: const EdgeInsets.all(16),
      itemBuilder: (context, index) {
        return _buildSkeletonItem(context);
      },
    );
  }

  Widget _buildSkeletonItem(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 标题骨架
          _buildShimmer(
            Container(
              width: double.infinity,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // 副标题骨架
          _buildShimmer(
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              height: 14,
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // 内容骨架
          Row(
            children: [
              _buildShimmer(
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildShimmer(
                      Container(
                        width: double.infinity,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildShimmer(
                      Container(
                        width: MediaQuery.of(context).size.width * 0.4,
                        height: 12,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmer(Widget child) {
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade200,
          Colors.grey.shade100,
          Colors.grey.shade200,
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      child: child,
    );
  }
}

/// 闪烁动画组件
class Shimmer extends StatefulWidget {
  final Widget child;
  final Gradient gradient;

  const Shimmer({
    Key? key,
    required this.child,
    required this.gradient,
  }) : super(key: key);

  @override
  State<Shimmer> createState() => _ShimmerState();
}

class _ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
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
        return GradientMask(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: widget.gradient.colors,
            stops: widget.gradient.stops,
          ),
          offset: _animation.value,
          child: widget.child,
        );
      },
    );
  }
}

/// 渐变遮罩组件
class GradientMask extends StatelessWidget {
  final Gradient gradient;
  final Widget child;
  final double offset;

  const GradientMask({
    Key? key,
    required this.gradient,
    required this.child,
    this.offset = 0.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      shaderCallback: (bounds) {
        return gradient.createShader(
          Rect.fromLTWH(
            bounds.left + offset * bounds.width,
            bounds.top,
            bounds.width,
            bounds.height,
          ),
        );
      },
      blendMode: BlendMode.srcATop,
      child: child,
    );
  }
}

/// 圆形骨架屏（用于头像等）
class CircleSkeletonWidget extends StatelessWidget {
  final double size;

  const CircleSkeletonWidget({
    Key? key,
    this.size = 60,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer(
      gradient: LinearGradient(
        colors: [
          Colors.grey.shade200,
          Colors.grey.shade100,
          Colors.grey.shade200,
        ],
        stops: const [0.0, 0.5, 1.0],
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}
