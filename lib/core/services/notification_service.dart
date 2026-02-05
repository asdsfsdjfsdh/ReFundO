import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:refundo/core/utils/log_util.dart';

/// 通知服务
/// 负责本地通知的创建和显示
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  /// 初始化通知服务
  Future<void> initialize() async {
    if (_initialized) return;

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/launcher_icon');

    const DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );

    await _notifications.initialize(initializationSettings);

    // 创建通知渠道（Android）
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'refund_notification_channel',
      'RefundO Notifications',
      description: '通知渠道',
      importance: Importance.high,
      enableVibration: true,
      playSound: true,
    );

    await _notifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);

    _initialized = true;
    LogUtil.d('NotificationService', '通知服务初始化完成');
  }

  /// 显示退款状态更新通知
  Future<void> showRefundStatusNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    if (!_initialized) {
      await initialize();
    }

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'refund_notification_channel',
      'RefundO Notifications',
      channelDescription: '通知渠道',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
    );

    const DarwinNotificationDetails darwinPlatformChannelSpecifics =
        DarwinNotificationDetails();

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: darwinPlatformChannelSpecifics,
    );

    await _notifications.show(
      0,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );

    LogUtil.d('NotificationService', '通知已发送: $title');
  }

  /// 显示订单同步通知
  Future<void> showOrderSyncNotification({
    required int successCount,
    required int failedCount,
  }) async {
    String title = '订单同步完成';
    String body = '成功同步 $successCount 条订单';
    if (failedCount > 0) {
      body += '，失败 $failedCount 条';
    }

    await showRefundStatusNotification(
      title: title,
      body: body,
      payload: 'order_sync',
    );
  }

  /// 显示退款申请批准通知
  Future<void> showRefundApprovedNotification({
    required String orderNumber,
    required double amount,
  }) async {
    await showRefundStatusNotification(
      title: '退款申请已批准',
      body: '订单 $orderNumber 的退款申请已通过，金额: ${amount.toStringAsFixed(2)} FCFA',
      payload: 'refund_approved',
    );
  }

  /// 显示退款申请拒绝通知
  Future<void> showRefundRejectedNotification({
    required String orderNumber,
    required String reason,
  }) async {
    await showRefundStatusNotification(
      title: '退款申请已拒绝',
      body: '订单 $orderNumber 的退款申请被拒绝，原因: $reason',
      payload: 'refund_rejected',
    );
  }

  /// 显示系统通知
  Future<void> showSystemNotification({
    required String title,
    required String body,
  }) async {
    await showRefundStatusNotification(
      title: title,
      body: body,
      payload: 'system_notification',
    );
  }
}
