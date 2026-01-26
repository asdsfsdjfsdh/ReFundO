# 前后端文本展示逻辑改造方案

## 一、背景分析

### 1.1 现有问题

| 问题 | 描述 | 影响 |
|-----|------|-----|
| Flutter未发送Accept-Language头 | 前端API请求未携带语言偏好头 | 后端始终使用默认中文返回消息 |
| 前端定义了错误键但未使用 | `app_*.arb` 中有本地化键，但直接显示后端消息 | 前端本地化资源浪费 |
| 硬编码网络错误 | API Service 中硬编码中文错误消息 | 无法跟随语言切换 |

### 1.2 后端响应格式

```json
{
  "code": 1,          // 1=成功, 0=失败
  "data": {...},       // 业务数据
  "message": null      // 成功时null，失败时错误消息（已本地化）
}
```

### 1.3 现有架构流程

```
后端 → API Service → Model(errorMessage) → Provider → UI
                     ↑ 仅用于错误，成功时为空
```

---

## 二、改造方案

### 2.1 核心设计

**原则：**
- `code = 1`：前端显示本地化的成功消息
- `code = 0`：前端显示后端返回的错误消息

**方案：扩展 Model 添加 `successMessageKey`**

### 2.2 新架构流程

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              请求响应流程                                     │
├─────────────────────────────────────────────────────────────────────────────┤
│                                                                             │
│  后端                           前端                                         │
│  ────────────────────────────  ────────────────────────────                 │
│                                                                             │
│  返回: {                     API Service                                    │
│    code: 1,                   │                                             │
│    data: {...},               ├─ code=1 → Model(                             │
│    message: null              │         successMessageKey: 'login_success' │
│  }                            │                                              │
│                               ├─ code=0 → Model(                             │
│  返回: {                      │         errorMessage: "用户不存在"           │
│    code: 0,                   │                                              │
│    data: null,                │                                              │
│    message: "用户不存在"       │                                              │
│  }                            │                                              │
│                               ▼                                              │
│                            Provider                                         │
│                               │                                              │
│                               ├─ success:true → {messageKey, data}          │
│                               └─ success:false → {message}                   │
│                               │                                              │
│                               ▼                                              │
│                            UI Layer                                         │
│                               │                                              │
│                               ├─ success → l10n.login_success                │
│                               └─ failure → "用户不存在" (后端消息)            │
│                                                                             │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 三、实施计划

### Phase 1: 用户模块 (6个任务)

#### 任务 #1: Model层改造
**文件：** `lib/models/user_model.dart`

**改动：**
```dart
class UserModel {
  // ... 现有字段 ...

  final String errorMessage;       // 已有，保留
  final String successMessageKey;  // 新增：成功消息的l10n键

  UserModel({
    // ... 现有参数 ...
    this.errorMessage = '',
    this.successMessageKey = '',    // 新增
  });

  factory UserModel.fromJson(Map<String, dynamic> json, {
    String errorMessage = '',
    String successMessageKey = '',  // 新增
  }) {
    // ...
    return UserModel(
      // ...
      errorMessage: errorMessage,
      successMessageKey: successMessageKey,
    );
  }
}
```

---

#### 任务 #2: API Service层改造
**文件：** `lib/data/services/api_user_logic_service.dart`

| 方法 | 成功消息键 |
|-----|-----------|
| `logic()` (登录) | `login_success` |
| `register()` (注册) | `register_success` |
| `updateUserInfo()` | 根据updateType：<br>- 1: `update_username_success`<br>- 2: `update_password_success`<br>- 3: `update_email_success`<br>- 4: `update_phone_success` |
| `getUserInfo()` | `get_user_info_success` |

**改动示例：**
```dart
if (responseData['code'] == 1 && responseData['data'] != null) {
  return UserModel.fromJson(
    responseData,
    successMessageKey: 'login_success',  // 新增
  );
} else {
  String message = responseData['message'] ?? '未知错误';
  return UserModel.fromJson({}, errorMessage: message);
}
```

---

#### 任务 #3: Provider层改造
**文件：** `lib/features/main/pages/setting/provider/user_provider.dart`

**新返回格式：**
```dart
// 成功 (code=1)
{
  'success': true,
  'data': userModel,
  'messageKey': 'login_success'
}

// 失败 (code=0)
{
  'success': false,
  'message': '用户不存在'  // 后端错误消息
}
```

**改动方法：**
- `login()` - 返回 `Future<Map<String, dynamic>>`
- `register()` - 返回 `Future<Map<String, dynamic>>`
- `updateUserInfo()` - 返回 `Future<Map<String, dynamic>>`
- `verifyUserIdentity()` - 返回 `Future<Map<String, dynamic>>`

---

#### 任务 #4: UI层改造 - 登录页面
**文件：** `lib/core/widgets/floating_login.dart`

```dart
var result = await userProvider.login(username, password, context);

if (result['success']) {
  // code=1: 使用前端l10n显示成功消息
  String messageKey = result['messageKey'];
  String successMessage = _getSuccessMessage(messageKey, l10n);
  ShowToast.showSuccess(context, successMessage);
  // 跳转主页...
} else {
  // code=0: 显示后端返回的错误消息
  setState(() => _errorMessage = result['message']);
}

String _getSuccessMessage(String key, AppLocalizations? l10n) {
  switch (key) {
    case 'login_success': return l10n?.login_success ?? '登录成功';
    default: return '操作成功';
  }
}
```

---

#### 任务 #5: UI层改造 - 注册页面
**文件：** `lib/core/widgets/floating_register.dart`

同登录页模式，处理注册和验证码发送的结果。

---

#### 任务 #6: 添加本地化消息键
**文件：**
- `lib/l10n/app_zh.arb`
- `lib/l10n/app_en.arb`
- `lib/l10n/app_f.arb`

**新增内容：**
```json
{
  "login_success": "登录成功",
  "register_success": "注册成功",
  "get_user_info_success": "获取用户信息成功",
  "update_username_success": "用户名更新成功",
  "update_password_success": "密码修改成功",
  "update_email_success": "邮箱更新成功",
  "update_phone_success": "电话号码更新成功",
  "verification_code_sent": "验证码已发送",
  "verification_success": "验证成功"
}
```

---

### Phase 2: 订单模块 (4个任务)

| 任务 | 文件 | 成功消息键 |
|-----|------|-----------|
| #7 Model层 | `lib/models/order_model.dart` | 添加 `successMessageKey` 字段 |
| #8 API Service | `lib/data/services/api_order_service.dart` | `create_order_success`, `cancel_order_success`, `get_orders_success` |
| #9 Provider | `lib/features/main/pages/home/provider/order_provider.dart` | 返回结构化结果 |
| #10 本地化 | `lib/l10n/app_*.arb` | 添加对应翻译 |

---

### Phase 3: 退款模块 (4个任务)

| 任务 | 文件 | 成功消息键 |
|-----|------|-----------|
| #11 Model层 | `lib/models/refund_model.dart` | 添加 `successMessageKey` 字段 |
| #12 API Service | `lib/data/services/api_refund_service.dart` | `create_refund_success`, `cancel_refund_success`, `get_refunds_success` |
| #13 Provider | `lib/features/main/pages/home/provider/refund_provider.dart` | 返回结构化结果 |
| #14 本地化 | `lib/l10n/app_*.arb` | 添加对应翻译 |

---

### Phase 4: 产品模块 (2个任务)

| 任务 | 文件 | 成功消息键 |
|-----|------|-----------|
| #15 Model层 | `lib/models/Product_model.dart` | 添加 `successMessageKey` 字段 |
| #16 本地化 | `lib/l10n/app_*.arb` | `scan_product_success`, `get_product_success` |

---

### Phase 5: 验证码/邮件模块 (2个任务)

| 任务 | 文件 | 成功消息键 |
|-----|------|-----------|
| #17 Service | `lib/data/services/api_verification_service.dart`, `api_email_service.dart` | `send_verification_code_success`, `send_email_success` |
| #18 本地化 | `lib/l10n/app_*.arb` | 添加对应翻译 |

---

### Phase 6: UI层其他页面改造

**文件：** 所有调用 Provider 方法的 UI 组件

**改造模式：**
```dart
// 原代码
var result = await provider.someMethod();
if (result.errorMessage.isNotEmpty) {
  showError(result.errorMessage);
}

// 新代码
var result = await provider.someMethod();
if (result['success']) {
  ShowToast.showSuccess(context, l10n.{result['messageKey']});
} else {
  ShowToast.showError(context, result['message']);
}
```

---

### Phase 7: 扩展 ShowToast 辅助类

**文件：** `lib/core/utils/showToast.dart`

**新增方法：**
```dart
/// 显示成功消息（绿色字体）
static void showSuccess(BuildContext context, String message) {
  // 绿色字体的 Toast
}

/// 显示失败消息（红色字体）
static void showError(BuildContext context, String message) {
  // 红色字体的 Toast
}
```

---

### Phase 8: 测试与验证

**测试清单：**

| 模块 | 测试项 |
|-----|--------|
| 用户模块 | 登录成功/失败、注册成功/失败、修改信息成功/失败 |
| 订单模块 | 创建订单、取消订单、获取列表 |
| 退款模块 | 创建退款、取消退款、获取列表 |
| 多语言 | 中文/英文/法文环境下所有消息正确 |
| 边界 | 网络错误、服务器异常、未知错误 |

---

## 四、文件清单总览

| 层级 | 文件 |
|-----|------|
| **Model** | `user_model.dart`, `order_model.dart`, `refund_model.dart`, `Product_model.dart` |
| **API Service** | `api_user_logic_service.dart`, `api_order_service.dart`, `api_refund_service.dart`, `api_verification_service.dart`, `api_email_service.dart` |
| **Provider** | `user_provider.dart`, `order_provider.dart`, `refund_provider.dart` |
| **UI** | `floating_login.dart`, `floating_register.dart`, 其他UI文件 |
| **l10n** | `app_zh.arb`, `app_en.arb`, `app_f.arb` |
| **Utils** | `showToast.dart` (扩展) |

---

## 五、已完成改动

### 5.1 添加 Accept-Language 头

**文件：** `lib/features/main/pages/setting/provider/dio_provider.dart`

```dart
onRequest: (options, handler) async {
  final prefs = await SharedPreferences.getInstance();

  // 添加 Accept-Language 头
  final languageCode = prefs.getString('languageCode') ?? 'zh';
  final countryCode = prefs.getString('countryCode') ?? 'CN';
  final acceptLanguage = '$languageCode-$countryCode';
  options.headers['Accept-Language'] = acceptLanguage;

  return handler.next(options);
},
```

---

## 六、执行顺序

建议按 Phase 1 → Phase 8 顺序执行：
1. 先完成用户模块（最常用，验证方案可行性）
2. 再扩展到订单、退款模块
3. 最后完善其他模块和测试
