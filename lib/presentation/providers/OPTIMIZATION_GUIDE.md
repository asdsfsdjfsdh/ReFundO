# Provider 状态管理优化指南

## 优化总结

本文档说明了如何优化 Provider 状态管理，减少不必要的重建和内存使用。

---

## 1. 避免不必要的 notifyListeners() 调用

### ❌ 错误示例
```dart
Future<void> loadDarkMode() async {
  final prefs = await SharedPreferences.getInstance();
  _isDarkMode = prefs.getBool('darkMode') ?? false;
  notifyListeners(); // 总是通知，即使值没有变化
}
```

### ✅ 正确示例
```dart
Future<void> loadDarkMode() async {
  final prefs = await SharedPreferences.getInstance();
  final newValue = prefs.getBool('darkMode') ?? false;

  // 只在值变化时通知
  if (_isDarkMode != newValue) {
    _isDarkMode = newValue;
    notifyListeners();
  }
}
```

---

## 2. 使用 select() 减少重建

### ❌ 错误示例：整个 widget 重建
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Text(userProvider.user?.username ?? '');
  }
}
```

### ✅ 正确示例：只在特定值变化时重建
```dart
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final username = context.select((UserProvider p) => p.user?.username);

    return Text(username ?? '');
  }
}
```

---

## 3. 使用 Consumer 替代 Provider.of

### ❌ 错误示例：整个上下文重建
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Home')),
    body: Column(
      children: [
        SomeWidget(),
        Provider.of<UserProvider>(context).isLogin
            ? Text('Logged in')
            : Text('Logged out'),
      ],
    ),
  );
}
```

### ✅ 正确示例：只有 Consumer 部分重建
```dart
@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: Text('Home')),
    body: Column(
      children: [
        SomeWidget(),
        Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return userProvider.isLogin
                ? Text('Logged in')
                : Text('Logged out');
          },
        ),
      ],
    ),
  );
}
```

---

## 4. 分离 Provider 职责

### ❌ 错误示例：一个 Provider 做太多事情
```dart
class MegaProvider extends ChangeNotifier {
  UserModel? _user;
  List<OrderModel> _orders = [];
  List<RefundModel> _refunds = [];
  Locale _locale;
  bool _isDarkMode;

  // 所有状态和方法都在这里...
}
```

### ✅ 正确示例：分离职责
```dart
class UserProvider extends ChangeNotifier {
  UserModel? _user;
  // 只管理用户相关状态
}

class OrderProvider extends ChangeNotifier {
  List<OrderModel> _orders = [];
  // 只管理订单相关状态
}

class AppProvider extends ChangeNotifier {
  Locale _locale;
  bool _isDarkMode;
  // 只管理应用级别设置
}
```

---

## 5. 使用 Selector 过滤数据

### 示例：只监听订单列表长度
```dart
Selector<OrderProvider, int>(
  selector: (context, orderProvider) => orderProvider.orders.length,
  builder: (context, orderCount, child) {
    return Text('订单数: $orderCount');
  },
)
```

---

## 6. 优化 Context.watch() 和 Context.read()

### Context.watch() - 在 build 中使用（自动监听变化）
```dart
@override
Widget build(BuildContext context) {
  final user = context.watch<UserProvider>(); // 会在变化时重建
  return Text(user.username);
}
```

### Context.read() - 在事件处理中使用（不监听变化）
```dart
ElevatedButton(
  onPressed: () {
    context.read<UserProvider>().login(); // 不监听变化
  },
  child: Text('登录'),
)
```

---

## 7. 避免在 build 方法中调用 Provider.of

### ❌ 错误示例
```dart
@override
Widget build(BuildContext context) {
  // 每次构建都调用，可能导致无限循环
  Provider.of<UserProvider>(context, listen: false).doSomething();
  return Container();
}
```

### ✅ 正确示例
```dart
@override
Widget build(BuildContext context) {
  return ElevatedButton(
    onPressed: () {
      context.read<UserProvider>().doSomething();
    },
    child: Text('执行'),
  );
}
```

---

## 8. 使用 ChangeNotifier.proxyProvider 处理依赖

### 示例：依赖于其他 Provider 的 Provider
```dart
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => DioProvider()),
    ChangeNotifierProxyProvider<DioProvider, UserProvider>(
      create: (_) => UserProvider(),
      update: (_, dio, previous) => previous!..dio = dio.dio,
    ),
  ],
)
```

---

## 9. 避免内存泄漏

### ✅ 正确释放资源
```dart
class MyProvider extends ChangeNotifier {
  StreamSubscription? _subscription;
  Timer? _timer;

  void startListening() {
    _subscription = someStream.listen((data) {
      // 处理数据
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _timer?.cancel();
    super.dispose();
  }
}
```

---

## 10. 使用 Selector2 处理多个 Provider

### 示例：同时监听两个 Provider
```dart
Selector2<UserProvider, OrderProvider, Tuple2<UserModel?, List<OrderModel>>>(
  selector: (context, userProvider, orderProvider) {
    return Tuple2(userProvider.user, orderProvider.orders);
  },
  builder: (context, data, child) {
    return Column(
      children: [
        Text('用户: ${data.item1?.username}'),
        Text('订单数: ${data.item2.length}'),
      ],
    );
  },
)
```

---

## 实施建议

1. **优先级**：
   - 高优先级：修复 `notifyListeners()` 滥用
   - 中优先级：使用 `Consumer` 和 `select()`
   - 低优先级：重构 Provider 架构

2. **测试**：
   - 使用 Flutter DevTools 检查重建次数
   - 监控内存使用情况
   - 测试在不同状态下的性能

3. **渐进式优化**：
   - 不要一次性改动太多
   - 每次优化后测试功能完整性
   - 使用性能分析工具验证改进效果

---

## 常见问题

### Q: 什么时候使用 Consumer vs Selector?
A:
- `Consumer`：简单 UI 更新，需要访问整个 Provider
- `Selector`：只需要特定字段，需要过滤/转换数据

### Q: notifyListeners() 应该在什么时候调用?
A: 只在数据真正变化时调用，避免在数据未变化时调用

### Q: 如何判断 widget 是否重建次数过多?
A: 使用 Flutter DevTools 的性能分析功能，或者添加 `print` 语句到 `build` 方法

---

## 相关资源

- [Provider 官方文档](https://pub.dev/packages/provider)
- [Flutter 性能优化指南](https://flutter.dev/docs/perf/rendering/best-practices)
- [Flutter DevTools](https://flutter.dev/docs/development/tools/devtools/overview)
