# refundo

A new Flutter project.

## Getting Started

## 常用命令
# ARB文件生成Dart代码
flutter gen-l10n

# 项目框架
- asset 资源管理
  - images 图片资源
- lib
  - core 工具类
    - constants 常量管理工具
    - permissions 权限管理工具
    - utils 常用工具
      - log_util.dart debug 终端弹幕工具
      - showToast.dart 消息提示工具
      - passwordHasher.dart 密码哈希加密工具
    - widgets 全局共享组件
  - data 后端数据类
  - features 页面类
    - main 主页面
    - start 启动页面
  - routes 路由类
  - l10n 语言转换本地化资源文件
  - main.dart 主程序入口