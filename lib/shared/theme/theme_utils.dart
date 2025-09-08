import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'color_theme.dart';
import 'dialog_theme.dart';
import '../../features/settings/presentation/providers/settings_provider.dart';

/// 主题工具类
/// 
/// 提供便捷的主题访问和操作方法
class ThemeUtils {
  ThemeUtils._();

  /// 从ColorScheme推断当前的AppColorTheme
  /// 
  /// 通过比较当前主题的primary颜色来推断使用的颜色主题
  static AppColorTheme inferColorTheme(ColorScheme colorScheme) {
    final currentPrimary = colorScheme.primary;
    
    // 计算颜色距离，找到最接近的主题
    double minDistance = double.infinity;
    AppColorTheme closestTheme = AppColorTheme.purple;
    
    for (final theme in AppColorTheme.values) {
      final themeColor = ColorThemeConfig.getPrimaryColor(theme);
      final distance = _calculateColorDistance(currentPrimary, themeColor);
      
      if (distance < minDistance) {
        minDistance = distance;
        closestTheme = theme;
      }
    }
    
    return closestTheme;
  }
  
  /// 计算两个颜色之间的距离
  static double _calculateColorDistance(Color color1, Color color2) {
    final r1 = (color1.r * 255.0).round() & 0xff;
    final g1 = (color1.g * 255.0).round() & 0xff;
    final b1 = (color1.b * 255.0).round() & 0xff;
    
    final r2 = (color2.r * 255.0).round() & 0xff;
    final g2 = (color2.g * 255.0).round() & 0xff;
    final b2 = (color2.b * 255.0).round() & 0xff;
    
    return ((r1 - r2) * (r1 - r2) + (g1 - g2) * (g1 - g2) + (b1 - b2) * (b1 - b2)).toDouble();
  }
}

/// BuildContext的主题扩展
extension ThemeExtension on BuildContext {
  /// 获取当前的颜色主题
  AppColorTheme get currentColorTheme {
    final colorScheme = Theme.of(this).colorScheme;
    return ThemeUtils.inferColorTheme(colorScheme);
  }
  
  /// 创建主题化的AlertDialog
  AlertDialog createThemedAlert({
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    bool scrollable = false,
  }) {
    final colorTheme = currentColorTheme;
    return DialogThemeConfig.createThemedAlertDialog(
      context: this,
      colorTheme: colorTheme,
      title: title,
      content: content,
      actions: actions,
      scrollable: scrollable,
    );
  }
  
  /// 显示主题化的AlertDialog
  Future<T?> showThemedDialog<T>({
    required WidgetBuilder builder,
    bool barrierDismissible = true,
    Color? barrierColor,
    String? barrierLabel,
    bool useRootNavigator = true,
    RouteSettings? routeSettings,
  }) {
    return showDialog<T>(
      context: this,
      builder: builder,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel: barrierLabel,
      useRootNavigator: useRootNavigator,
      routeSettings: routeSettings,
    );
  }
  
  /// 显示主题化的简单确认对话框
  Future<bool?> showThemedConfirmDialog({
    required String title,
    required String content,
    String confirmText = '确定',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
  }) {
    final colorTheme = currentColorTheme;
    final brightness = Theme.of(this).brightness;
    final primaryColor = ColorThemeConfig.getPrimaryColor(colorTheme);
    
    return showDialog<bool>(
      context: this,
      builder: (context) => DialogThemeConfig.createThemedAlertDialog(
        context: context,
        colorTheme: colorTheme,
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () {
              onCancel?.call();
              Navigator.of(context).pop(false);
            },
            child: Text(cancelText),
          ),
          FilledButton(
            onPressed: () {
              onConfirm?.call();
              Navigator.of(context).pop(true);
            },
            style: FilledButton.styleFrom(
              backgroundColor: isDangerous 
                  ? (brightness == Brightness.light ? Colors.red : Colors.red.shade400)
                  : primaryColor,
              foregroundColor: Colors.white,
            ),
            child: Text(confirmText),
          ),
        ],
      ),
    );
  }
}

/// WidgetRef的主题扩展（用于Riverpod）
extension ThemeRefExtension on WidgetRef {
  /// 获取当前的应用设置中的颜色主题
  AppColorTheme get currentColorTheme {
    return watch(settingsProvider).colorTheme;
  }
}

/// 便捷的主题化对话框构建器
class ThemedDialogBuilder {
  final BuildContext context;
  final AppColorTheme colorTheme;
  
  ThemedDialogBuilder(this.context, this.colorTheme);
  
  /// 创建简单的信息对话框
  AlertDialog createInfoDialog({
    required String title,
    required String content,
    String buttonText = '确定',
    VoidCallback? onPressed,
  }) {
    return DialogThemeConfig.createThemedAlertDialog(
      context: context,
      colorTheme: colorTheme,
      title: Text(title),
      content: Text(content),
      actions: [
        FilledButton(
          onPressed: () {
            onPressed?.call();
            Navigator.of(context).pop();
          },
          child: Text(buttonText),
        ),
      ],
    );
  }
  
  /// 创建确认对话框
  AlertDialog createConfirmDialog({
    required String title,
    required String content,
    String confirmText = '确定',
    String cancelText = '取消',
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    bool isDangerous = false,
  }) {
    final brightness = Theme.of(context).brightness;
    final primaryColor = ColorThemeConfig.getPrimaryColor(colorTheme);
    
    return DialogThemeConfig.createThemedAlertDialog(
      context: context,
      colorTheme: colorTheme,
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () {
            onCancel?.call();
            Navigator.of(context).pop(false);
          },
          child: Text(cancelText),
        ),
        FilledButton(
          onPressed: () {
            onConfirm?.call();
            Navigator.of(context).pop(true);
          },
          style: FilledButton.styleFrom(
            backgroundColor: isDangerous 
                ? (brightness == Brightness.light ? Colors.red : Colors.red.shade400)
                : primaryColor,
            foregroundColor: Colors.white,
          ),
          child: Text(confirmText),
        ),
      ],
    );
  }
}
