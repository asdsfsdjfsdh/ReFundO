import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/models/initialization_model.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:refundo/core/utils/log_util.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _textSlideAnimation;

  @override
  void initState() {
    super.initState();

    // 初始化动画控制器
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );

    // 配置动画曲线和参数
    _setupAnimations();

    // 启动动画
    _animationController.forward();

    // 原有的初始化逻辑保持不变
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final initModel = Provider.of<InitializationModel>(context, listen: false);
      initModel.initializeApp(context);
    });
  }

  // 配置动画参数
  void _setupAnimations() {
    _opacityAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(
      begin: 0.7,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.elasticOut),
      ),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<InitializationModel>(
      builder: (context, initModel, child) {
        // 初始化完成时导航到主页面
        if (initModel.currentStatus == InitializationStatus.complete) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushReplacementNamed('/');
          });
        }

        return Scaffold(
          backgroundColor: Colors.blue.shade700, // 使用品牌主色调
          body: SafeArea(
            child: _buildAnimatedContent(initModel),
          ),
        );
      },
    );
  }

  // 构建动画内容
  Widget _buildAnimatedContent(InitializationModel initModel) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: _buildMainContent(initModel),
    );
  }

  // 构建主要内容区域
  Widget _buildMainContent(InitializationModel initModel) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Logo区域
          _buildLogoSection(),
          const SizedBox(height: 40),

          // 状态信息区域
          _buildStatusSection(initModel),
          const SizedBox(height: 32),

          // 进度指示器
          _buildProgressIndicator(),
        ],
      ),
    );
  }

  // 构建Logo区域
  Widget _buildLogoSection() {
    return Column(
      children: [
        // Logo容器
        Container(
          width: 140,
          height: 140,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(28.0),
            child: _buildLogoImage(),
          ),
        ),
        const SizedBox(height: 24),

        // 应用名称
        SlideTransition(
          position: _textSlideAnimation,
          child: Text(
            AppLocalizations.of(context)!.app_name, // 多语言支持
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              letterSpacing: 1.2,
            ),
          ),
        ),

        // 应用标语
        SlideTransition(
          position: _textSlideAnimation,
          child: Text(
            AppLocalizations.of(context)!.app_slogan, // 多语言支持
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w300,
            ),
          ),
        ),
      ],
    );
  }

  // 构建Logo图片
  Widget _buildLogoImage() {
    // 如果有自定义Logo图片，使用Image.asset
    // return Image.asset('assets/images/logo.png');

    // 临时使用Flutter图标作为占位
    return Icon(
      Icons.account_balance_wallet_rounded,
      size: 60,
      color: Colors.blue.shade700,
    );
  }

  // 构建状态信息区域
  Widget _buildStatusSection(InitializationModel initModel) {
    return SlideTransition(
      position: _textSlideAnimation,
      child: Column(
        children: [
          // 状态文本
          Text(
            initModel.getCurrentStatusText(context),
            style: TextStyle(
              fontSize: 16,
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),

          // 加载提示
          Text(
            _getLoadingSubtitle(context, initModel.currentStatus), // 传入context
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withOpacity(0.7),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // 根据状态获取加载副标题 - 添加多语言支持
  String _getLoadingSubtitle(BuildContext context, InitializationStatus status) {
    final l10n = AppLocalizations.of(context);

    switch (status) {
      case InitializationStatus.starting:
        return l10n!.starting_initialization;
      case InitializationStatus.loadingData:
        return l10n!.loading_user_data;
      case InitializationStatus.unknown:
        return l10n!.unknown_error;
      case InitializationStatus.complete:
        return l10n!.ready;
      default:
        return l10n!.initializing;
    }
  }

  // 构建进度指示器
  Widget _buildProgressIndicator() {
    return SlideTransition(
      position: _textSlideAnimation,
      child: SizedBox(
        width: 32,
        height: 32,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          valueColor: AlwaysStoppedAnimation<Color>(
            Colors.white.withOpacity(0.9),
          ),
        ),
      ),
    );
  }
}