# ReFundO 新功能实现任务清单

## 项目概述

本文档详细说明了 ReFundO 项目需要添加的四个新功能及其实施方案。

---

## 功能一：申请退款时添加优惠凭证图片

### 需求描述
在申请退款时，用户可以上传优惠凭证（优惠券、折扣券等）图片，帮助系统计算更准确的退款金额。

### 后端改造

#### 1.1 修改 RefundRequest 实体类
**文件**: `E:\java\ReFundO\pojo\src\main\java\org\example\refundo\Pojo\RefundRequest.java`

```java
// 添加字段
private String discountUrl; // 优惠凭证图片URL
```

#### 1.2 修改 RefundRequestDTO
**文件**: `E:\java\ReFundO\pojo\src\main\java\org\example\refundo\DTO\RefundRequestDTO.java`

```java
// 添加字段
private String discountUrl; // 优惠凭证URL
```

#### 1.3 修改数据库表结构
**文件**: `E:\java\ReFundO\server\src\main\resources\mapper\RefundRequestMapper.xml`

添加 discount_url 字段到 SQL 语句中。

#### 1.4 修改 RefundRequestService
**文件**: `E:\java\ReFundO\server\src\main\java\org\example\refundo\Service\Impl\RefundRequestServiceImpl.java`

更新 createRefundRequest 方法，添加 discountUrl 参数处理。

### 前端改造

#### 1.5 修改 RefundConfirmationDialog
**文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\features\main\pages\home\widgets\refund_confirmation_dialog.dart`

- 添加图片上传功能
- 使用 image_picker 包选择图片
- 调用 OSS 上传接口获取 URL
- 在提交时包含 discountUrl

#### 1.6 修改 ApiOrderService
**文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\data\services\api_order_service.dart`

在 Refund 方法中添加 discountUrl 参数。

#### 1.7 添加图片上传工具类
**新建文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\core\utils\image_upload.dart`

实现图片选择和 OSS 上传功能。

---

## 功能二：用户修改头像

### 需求描述
用户可以上传自定义头像，当头像加载失败时使用默认的头像展示方式（首字母占位符）。

### 后端改造

#### 2.1 修改 User 实体类
**文件**: `E:\java\ReFundO\pojo\src\main\java\org\example\refundo\Pojo\User.java`

确认 avatarUrl 字段存在（已存在）。

#### 2.2 添加头像上传接口
**文件**: `E:\java\ReFundO\server\src\main\java\org\example\refundo\Controller\UserController.java`

```java
/**
 * 上传用户头像
 * @param file 头像文件
 * @return 头像URL
 */
@PostMapping("/avatar")
public Result<String> uploadAvatar(@RequestParam("file") MultipartFile file) {
    String avatarUrl = userService.uploadAvatar(file);
    return Result.success(avatarUrl);
}
```

#### 2.3 实现 UserService 头像上传方法
**文件**: `E:\java\ReFundO\server\src\main\java\org\example\refundo\Service\Impl\UserServiceImpl.java`

使用 AliOssUtil 实现头像上传和更新。

### 前端改造

#### 2.4 修改 UserProfileCard
**文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\features\main\pages\setting\widgets\user_profile_card.dart`

- 添加头像点击事件
- 显示头像编辑选项（拍照/相册/删除）
- 使用现有的 CachedNetworkImage 错误处理机制（已实现）

#### 2.5 添加头像编辑对话框
**新建文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\features\main\pages\setting\widgets\avatar_edit_dialog.dart`

实现头像选择、预览和上传功能。

#### 2.6 添加头像上传 API 服务
**文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\data\services\api_user_logic_service.dart`

添加 uploadAvatar 方法。

---

## 功能三：重构退款请求状态图标

### 需求描述
根据 request_status 的值展示不同的图标和颜色：
- 0 - 待处理 (Pending)
- 1 - 已批准 (Approved)
- 2 - 已拒绝 (Rejected)
- 3 - 处理中 (Processing)
- 4 - 已完成 (Completed)
- 5 - 失败 (Failed)

### 前端改造

#### 3.1 修改 RefundWidget
**文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\features\main\pages\home\widgets\refund_widget.dart`

修改 `_buildStatusIcon` 方法：

```dart
Widget _buildStatusIcon(RefundModel refund) {
  final IconData icon;
  final Color color;

  switch (refund.requestStatus) {
    case 0: // 待处理
      icon = Icons.pending_outlined;
      color = Colors.orange.shade600;
      break;
    case 1: // 已批准
      icon = Icons.approval_outlined;
      color = Colors.green.shade600;
      break;
    case 2: // 已拒绝
      icon = Icons.cancel_outlined;
      color = Colors.red.shade600;
      break;
    case 3: // 处理中
      icon = Icons.sync_outlined;
      color = Colors.blue.shade600;
      break;
    case 4: // 已完成
      icon = Icons.check_circle_outline_rounded;
      color = Colors.green.shade700;
      break;
    case 5: // 失败
      icon = Icons.error_outline_rounded;
      color = Colors.red.shade700;
      break;
    default:
      icon = Icons.help_outline;
      color = Colors.grey.shade600;
  }

  return Container(
    width: 48,
    height: 48,
    decoration: BoxDecoration(
      color: color.withOpacity(0.1),
      shape: BoxShape.circle,
    ),
    child: Icon(icon, color: color, size: 24),
  );
}
```

修改 `_buildStatusBadge` 方法：

```dart
Widget _buildStatusBadge(BuildContext context, int status) {
  final l10n = AppLocalizations.of(context);
  final Color backgroundColor;
  final Color textColor;
  final String displayText;

  switch (status) {
    case 0:
      backgroundColor = Colors.orange.shade50;
      textColor = Colors.orange.shade800;
      displayText = l10n!.status_pending;
      break;
    case 1:
      backgroundColor = Colors.green.shade50;
      textColor = Colors.green.shade800;
      displayText = l10n!.status_approved;
      break;
    case 2:
      backgroundColor = Colors.red.shade50;
      textColor = Colors.red.shade800;
      displayText = l10n!.status_rejected;
      break;
    case 3:
      backgroundColor = Colors.blue.shade50;
      textColor = Colors.blue.shade800;
      displayText = l10n!.status_processing;
      break;
    case 4:
      backgroundColor = Colors.green.shade50;
      textColor = Colors.green.shade800;
      displayText = l10n!.status_completed;
      break;
    case 5:
      backgroundColor = Colors.red.shade50;
      textColor = Colors.red.shade800;
      displayText = l10n!.status_failed;
      break;
    default:
      backgroundColor = Colors.grey.shade50;
      textColor = Colors.grey.shade800;
      displayText = l10n!.status_unknown;
  }

  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Text(
      displayText,
      style: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: textColor,
      ),
    ),
  );
}
```

#### 3.2 添加多语言支持
**文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\l10n\app_zh.arb`, `app_en.arb`, `app_f.arb`

添加新的状态文本：

```json
{
  "status_pending": "待处理",
  "status_approved": "已批准",
  "status_rejected": "已拒绝",
  "status_processing": "处理中",
  "status_completed": "已完成",
  "status_failed": "失败",
  "status_unknown": "未知状态"
}
```

---

## 功能四：退款详情展示交易记录

### 需求描述
点击退款请求查看详情时，展示该退款请求关联的 RefundTransactions 数据。

交易状态 TransStatus：
- 0 - 待处理 (Pending)
- 1 - 成功 (Success)
- 2 - 失败 (Failed)
- 3 - 处理中 (Processing)

### 后端改造

#### 4.1 确认接口存在
**文件**: `E:\java\ReFundO\server\src\main\java\org\example\refundo\Controller\RefundRequestController.java`

接口 `GET /api/refund-request/{id}` 已存在，返回 TransactionVO。

### 前端改造

#### 4.2 创建 RefundTransaction 模型
**新建文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\models\refund_transaction_model.dart`

```dart
class RefundTransactionModel {
  final int transId;
  final int requestId;
  final String refundNumber;
  final int transStatus;
  final String remittanceReceipt;
  final String createTime;
  final String updateTime;

  RefundTransactionModel({
    required this.transId,
    required this.requestId,
    required this.refundNumber,
    required this.transStatus,
    required this.remittanceReceipt,
    required this.createTime,
    required this.updateTime,
  });

  factory RefundTransactionModel.fromJson(Map<String, dynamic> json) {
    return RefundTransactionModel(
      transId: json['transId'] as int? ?? 0,
      requestId: json['requestId'] as int? ?? 0,
      refundNumber: json['refundNumber'] as String? ?? '',
      transStatus: json['transStatus'] as int? ?? 0,
      remittanceReceipt: json['remittanceReceipt'] as String? ?? '',
      createTime: json['createTime'] as String? ?? '',
      updateTime: json['updateTime'] as String? ?? '',
    );
  }
}
```

#### 4.3 添加获取交易详情 API
**文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\data\services\api_refund_service.dart`

```dart
Future<Map<String, dynamic>> getRefundTransaction(BuildContext context, int requestId) async {
  try {
    DioProvider dioProvider = Provider.of<DioProvider>(context, listen: false);

    Response response = await dioProvider.dio.get('/api/refund-request/$requestId');

    final Map<String, dynamic> responseData = response.data;
    int code = responseData['code'] as int? ?? 0;

    if (code == 1 && responseData['data'] != null) {
      return {'success': true, 'data': responseData['data']};
    } else {
      return {'success': false, 'data': null};
    }
  } catch (e) {
    return {'success': false, 'data': null};
  }
}
```

#### 4.4 修改 _RefundDetailSheet
**文件**: `E:\Android\Project\ReFundO001_star_zjx\lib\features\main\pages\home\widgets\refund_widget.dart`

重构 `_RefundDetailSheet`，使其能够：
1. 在打开时加载交易数据
2. 显示退款请求基本信息
3. 显示关联的交易记录列表
4. 为每条交易记录显示状态图标

```dart
class _RefundDetailSheet extends StatefulWidget {
  final RefundModel refund;

  const _RefundDetailSheet({required this.refund});

  @override
  State<_RefundDetailSheet> createState() => _RefundDetailSheetState();
}

class _RefundDetailSheetState extends State<_RefundDetailSheet> {
  RefundTransactionModel? _transaction;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTransaction();
  }

  Future<void> _loadTransaction() async {
    final result = await ApiRefundService().getRefundTransaction(
      context,
      widget.refund.requestId,
    );

    if (result['success'] && result['data'] != null) {
      setState(() {
        _transaction = RefundTransactionModel.fromJson(result['data']);
        _isLoading = false;
      });
    } else {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // ... 实现详情页面 UI
  }
}
```

---

## 依赖项

### 前端需要添加的包

**文件**: `E:\Android\Project\ReFundO001_star_zjx\pubspec.yaml`

```yaml
dependencies:
  image_picker: ^1.0.0  # 图片选择
  # cached_network_image: 已存在
```

---

## 实施优先级

1. **高优先级**: 功能三（重构退款请求状态图标）- 纯前端改动，影响用户体验
2. **高优先级**: 功能四（展示交易记录）- 完善退款详情页
3. **中优先级**: 功能二（用户修改头像）- 提升用户个性化体验
4. **中优先级**: 功能一（优惠凭证上传）- 业务功能增强

---

## 测试要点

### 功能一测试
- [ ] 上传优惠凭证图片
- [ ] 验证图片是否正确上传到 OSS
- [ ] 验证 discountUrl 是否正确保存到数据库
- [ ] 测试图片格式支持

### 功能二测试
- [ ] 测试头像上传功能
- [ ] 测试头像加载失败时的降级显示
- [ ] 测试头像删除功能（恢复默认）
- [ ] 验证头像更新后其他页面的同步显示

### 功能三测试
- [ ] 验证所有 6 种状态的图标显示
- [ ] 验证不同语言下的状态文本
- [ ] 测试边界情况（未知状态）

### 功能四测试
- [ ] 测试退款详情页加载交易数据
- [ ] 验证交易状态图标显示
- [ ] 测试无交易记录时的显示
- [ ] 测试网络错误时的处理

---

## 注意事项

1. **图片上传大小限制**: 建议限制图片大小不超过 5MB
2. **图片格式**: 支持 JPG、PNG 格式
3. **头像裁剪**: 建议添加头像裁剪功能，保证显示效果
4. **错误处理**: 所有网络请求都需要完善的错误处理
5. **多语言**: 所有新增的 UI 文本都需要添加多语言支持
6. **向后兼容**: 确保旧数据在没有 discountUrl 时也能正常工作

---

**文档创建时间**: 2026-01-26
**版本**: v1.0
