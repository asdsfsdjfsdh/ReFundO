import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarWidget extends StatelessWidget {
  final String userImageUrl;
  final String username;
  final double size;
  final bool useLocalImage;
  final double borderRadius;
  final Color backgroundColor;
  final Color textColor;
  final bool showBorder;
  final Color borderColor;
  final double borderWidth;

  const AvatarWidget({
    super.key,
    required this.userImageUrl,
    required this.username,
    this.size = 40.0,
    this.useLocalImage = false,
    this.borderRadius = 0.0, // 0.0表示圆形，>0表示圆角矩形
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.showBorder = false,
    this.borderColor = Colors.white,
    this.borderWidth = 2.0,
  });

  @override
  Widget build(BuildContext context) {
    // 确保在任何屏幕下保持1:1比例
    return SizedBox(
      width: size,
      height: size,
      child: AspectRatio(
        aspectRatio: 1.0,
        child: _buildAvatarContent(),
      ),
    );
  }

  Widget _buildAvatarContent() {
    final bool isCircular = borderRadius == 0.0;
    final double effectiveBorderRadius = isCircular ? size / 2 : borderRadius;

    return Container(
      decoration: BoxDecoration(
        shape: isCircular ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: isCircular ? null : BorderRadius.circular(effectiveBorderRadius),
        border: showBorder
            ? Border.all(
          color: borderColor,
          width: borderWidth,
          strokeAlign: BorderSide.strokeAlignOutside, // 抗锯齿处理[3](@ref)
        )
            : null,
        boxShadow: [
          if (showBorder)
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
        ],
      ),
      child: ClipOval(
        child: userImageUrl.isNotEmpty ? _buildImageAvatar() : _buildTextAvatar(),
      ),
    );
  }

  Widget _buildImageAvatar() {
    if (useLocalImage) {
      return Image.asset(
        userImageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) => _buildTextAvatar(),
      );
    } else {
      // 使用缓存的网络图片，优化性能
      return CachedNetworkImage(
        imageUrl: userImageUrl,
        width: size,
        height: size,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildLoadingPlaceholder(),
        errorWidget: (context, url, error) => _buildTextAvatar(),
        fadeInDuration: const Duration(milliseconds: 300),
        fadeOutDuration: const Duration(milliseconds: 300),
      );
    }
  }

  Widget _buildTextAvatar() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            backgroundColor.withOpacity(0.8),
            backgroundColor,
          ],
        ),
      ),
      child: Center(
        child: Text(
          _getDisplayText(),
          style: TextStyle(
            fontSize: size * 0.35, // 更合理的字体大小比例
            color: textColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingPlaceholder() {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: SizedBox(
          width: size * 0.4,
          height: size * 0.4,
          child: CircularProgressIndicator(
            strokeWidth: 2.0,
            valueColor: AlwaysStoppedAnimation<Color>(backgroundColor),
          ),
        ),
      ),
    );
  }

  String _getDisplayText() {
    if (username.isEmpty) return 'U';

    // 获取用户名首字母，支持中文
    final trimmedName = username.trim();
    if (trimmedName.isEmpty) return 'U';

    // 如果是中文，取第一个字符；如果是英文，取首字母大写
    final firstChar = trimmedName[0];
    if (firstChar.runes.length == 1 && firstChar.runes.first <= 127) {
      // 英文字母
      return firstChar.toUpperCase();
    } else {
      // 中文字符或其他字符
      return firstChar;
    }
  }
}