import 'package:flutter/material.dart';
import 'package:refundo/core/state/loading_state.dart';
import 'package:refundo/presentation/widgets/app_states.dart';

/// 简单的空状态组件
class EmptyState extends StatelessWidget {
  final String? message;

  const EmptyState({this.message, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.inbox, size: 64, color: Colors.grey),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ],
      ),
    );
  }
}

/// 简单的错误状态组件
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const ErrorState({
    required this.message,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
          if (onRetry != null) ...[
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('重试'),
            ),
          ],
        ],
      ),
    );
  }
}

/// 全屏空状态组件
class FullScreenEmptyState extends StatelessWidget {
  const FullScreenEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const EmptyState(message: '暂无数据'),
    );
  }
}

/// 全屏错误状态组件
class FullScreenErrorState extends StatelessWidget {
  final String message;
  final VoidCallback? onRetry;

  const FullScreenErrorState({
    required this.message,
    this.onRetry,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ErrorState(
        message: message,
        onRetry: onRetry,
      ),
    );
  }
}

/// 统一的加载状态组件
class LoadingStateBuilder<T> extends StatelessWidget {
  final LoadingState<T> state;
  final Widget Function(T data) successBuilder;
  final Widget Function(String message)? errorBuilder;
  final Widget Function()? loadingBuilder;
  final Widget Function()? emptyBuilder;
  final Widget Function()? idleBuilder;
  final VoidCallback? onRetry;
  final bool sliver;

  const LoadingStateBuilder({
    super.key,
    required this.state,
    required this.successBuilder,
    this.errorBuilder,
    this.loadingBuilder,
    this.emptyBuilder,
    this.idleBuilder,
    this.onRetry,
    this.sliver = false,
  });

  @override
  Widget build(BuildContext context) {
    final content = _buildContent(context);

    return sliver ? content as Widget : content;
  }

  Widget _buildContent(BuildContext context) {
    switch (state.status) {
      case LoadingStatus.idle:
        return idleBuilder?.call() ?? const SizedBox.shrink();

      case LoadingStatus.loading:
        return loadingBuilder?.call() ?? const LoadingIndicator();

      case LoadingStatus.success:
        if (state.data != null) {
          return successBuilder(state.data as T);
        }
        return emptyBuilder?.call() ?? const EmptyState();

      case LoadingStatus.error:
        return errorBuilder?.call(state.errorMessage ?? '未知错误') ??
            ErrorState(
              message: state.errorMessage ?? '加载失败',
              onRetry: onRetry,
            );

      case LoadingStatus.empty:
        return emptyBuilder?.call() ?? const EmptyState();
    }
  }
}

/// 全屏加载状态页面
class FullScreenLoadingState<T> extends StatelessWidget {
  final LoadingState<T> state;
  final Widget Function(T data) successBuilder;
  final String? title;
  final Widget? leading;
  final List<Widget>? actions;
  final VoidCallback? onRetry;

  const FullScreenLoadingState({
    super.key,
    required this.state,
    required this.successBuilder,
    this.title,
    this.leading,
    this.actions,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: title != null ? Text(title!) : null,
        leading: leading,
        actions: actions,
      ),
      body: LoadingStateBuilder<T>(
        state: state,
        successBuilder: successBuilder,
        loadingBuilder: () => const FullScreenLoadingIndicator(),
        errorBuilder: (message) => FullScreenErrorState(
          message: message,
          onRetry: onRetry,
        ),
        emptyBuilder: () => const FullScreenEmptyState(),
      ),
    );
  }
}

/// 加载指示器组件
class LoadingIndicator extends StatelessWidget {
  final String? message;
  final double size;

  const LoadingIndicator({
    super.key,
    this.message,
    this.size = 40.0,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: const CircularProgressIndicator(),
          ),
          if (message != null) ...[
            const SizedBox(height: 16),
            Text(
              message!,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ],
      ),
    );
  }
}

/// 全屏加载指示器
class FullScreenLoadingIndicator extends StatelessWidget {
  final String? message;

  const FullScreenLoadingIndicator({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            if (message != null) ...[
              const SizedBox(height: 16),
              Text(message!),
            ],
          ],
        ),
      ),
    );
  }
}

/// 底部加载更多指示器
class LoadMoreIndicator extends StatelessWidget {
  final bool isLoading;
  final bool hasMore;
  final VoidCallback? onLoadMore;
  final String? errorMessage;

  const LoadMoreIndicator({
    super.key,
    required this.isLoading,
    required this.hasMore,
    this.onLoadMore,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMore) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            '没有更多数据了',
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: onLoadMore,
              child: const Text('重试'),
            ),
          ],
        ),
      );
    }

    if (isLoading) {
      return const Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return const SizedBox.shrink();
  }
}

/// 带加载状态的按钮
class LoadingButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final String label;
  final Widget? icon;
  final ButtonStyle? style;
  final bool enabled;

  const LoadingButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
    required this.label,
    this.icon,
    this.style,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (enabled && !isLoading) ? onPressed : null,
      style: style,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (icon != null) ...[icon!, const SizedBox(width: 8)],
                Text(label),
              ],
            ),
    );
  }
}

/// 刷新加载包装器
class RefreshLoadWrapper<T> extends StatelessWidget {
  final LoadingState<T> state;
  final Future<void> Function() onRefresh;
  final Widget child;
  final Widget Function(BuildContext context, String error)? errorBuilder;

  const RefreshLoadWrapper({
    super.key,
    required this.state,
    required this.onRefresh,
    required this.child,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    if (state.isError) {
      return errorBuilder?.call(context, state.errorMessage ?? '加载失败') ??
          ErrorState(
            message: state.errorMessage ?? '加载失败',
            onRetry: () => onRefresh(),
          );
    }

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: state.isLoading
          ? const LoadingIndicator()
          : state.isEmpty
              ? const EmptyState()
              : child,
    );
  }
}

/// 分页加载控制器
class PagingController extends ChangeNotifier {
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;
  final int pageSize;

  PagingController({this.pageSize = 20});

  int get currentPage => _currentPage;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  /// 开始加载
  void startLoading() {
    _isLoading = true;
    notifyListeners();
  }

  /// 加载完成
  void loadComplete({bool hasMore = true}) {
    _isLoading = false;
    _hasMore = hasMore;
    notifyListeners();
  }

  /// 加载失败
  void loadFailed() {
    _isLoading = false;
    notifyListeners();
  }

  /// 重置
  void reset() {
    _currentPage = 1;
    _hasMore = true;
    _isLoading = false;
    notifyListeners();
  }

  /// 下一页
  void nextPage() {
    if (_hasMore && !_isLoading) {
      _currentPage++;
    }
  }

  /// 加载更多
  Future<void> loadMore(Future<bool> Function(int page, int size) loader) async {
    if (_isLoading || !_hasMore) return;

    startLoading();
    try {
      final hasMoreData = await loader(_currentPage, pageSize);
      loadComplete(hasMore: hasMoreData);
      if (hasMoreData) {
        nextPage();
      }
    } catch (e) {
      loadFailed();
    }
  }

  /// 刷新
  Future<void> refresh(Future<bool> Function(int page, int size) loader) async {
    reset();
    return loadMore(loader);
  }
}

/// 分页加载列表
class PagingListView<T> extends StatelessWidget {
  final PagingController controller;
  final Future<List<T>> Function(int page, int size) loader;
  final Widget Function(BuildContext context, T item, int index) itemBuilder;
  final Widget? Function(BuildContext context, int index)? separatorBuilder;
  final Widget Function(BuildContext context, String error)? errorBuilder;
  final EdgeInsets? padding;

  const PagingListView({
    super.key,
    required this.controller,
    required this.loader,
    required this.itemBuilder,
    this.separatorBuilder,
    this.errorBuilder,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationListener<ScrollNotification>(
      onNotification: (scrollInfo) {
        if (scrollInfo.metrics.pixels >= scrollInfo.metrics.maxScrollExtent * 0.8) {
          // 将 List<T> 类型的 loader 转换为 bool 类型
          controller.loadMore((page, size) async {
            final items = await loader(page, size);
            return items.isNotEmpty;
          });
        }
        return false;
      },
      child: ListView.separated(
        padding: padding,
        itemCount: 0, // 实际数据需要外部管理
        separatorBuilder: separatorBuilder != null
            ? (context, index) => separatorBuilder!(context, index)!
            : (context, index) => const Divider(),
        itemBuilder: (context, index) {
          // 提供一个默认的空项构建器，实际使用时应该由外部管理数据
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

/// 自定义进度指示器
class CustomProgressIndicator extends StatelessWidget {
  final double progress;
  final String? message;
  final Color? backgroundColor;
  final Color? valueColor;
  final double height;
  final BorderRadius? borderRadius;

  const CustomProgressIndicator({
    super.key,
    required this.progress,
    this.message,
    this.backgroundColor,
    this.valueColor,
    this.height = 4.0,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (message != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Text(
              message!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ClipRRect(
          borderRadius: borderRadius ?? BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress.clamp(0.0, 1.0),
            backgroundColor: backgroundColor,
            valueColor: AlwaysStoppedAnimation(
              valueColor ?? Theme.of(context).primaryColor,
            ),
            minHeight: height,
          ),
        ),
      ],
    );
  }
}

/// 带取消按钮的加载对话框
class LoadingDialogWithCancel extends StatelessWidget {
  final String message;
  final VoidCallback onCancel;

  const LoadingDialogWithCancel({
    super.key,
    required this.message,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(message),
          const SizedBox(height: 16),
          TextButton(
            onPressed: onCancel,
            child: const Text('取消'),
          ),
        ],
      ),
    );
  }
}

/// 显示加载对话框
void showLoadingDialog(
  BuildContext context, {
  String message = '加载中...',
  bool allowCancel = true,
  VoidCallback? onCancel,
}) {
  showDialog(
    context: context,
    barrierDismissible: allowCancel,
    builder: (context) => allowCancel
        ? LoadingDialogWithCancel(
            message: message,
            onCancel: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
          )
        : AlertDialog(
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircularProgressIndicator(),
                const SizedBox(height: 16),
                Text(message),
              ],
            ),
          ),
  );
}
