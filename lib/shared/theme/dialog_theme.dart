import 'package:flutter/material.dart';
import 'color_theme.dart';

/// 对话框主题配置类
/// 
/// 提供统一的对话框颜色方案，确保：
/// 1. 对话框背景跟随主题颜色
/// 2. 文字始终保持清晰可读（黑色/白色）
/// 3. 保持良好的对比度
/// 4. 模块化设计，易于维护
class DialogThemeConfig {
  DialogThemeConfig._();

  /// 获取对话框主题配置
  /// 
  /// [colorTheme] 当前应用的颜色主题
  /// [brightness] 亮度模式（亮色/暗色）
  static DialogThemeData getDialogTheme(AppColorTheme colorTheme, Brightness brightness) {
    final isLight = brightness == Brightness.light;
    final primaryColor = ColorThemeConfig.getPrimaryColor(colorTheme);
    
    return DialogThemeData(
      backgroundColor: _getDialogBackgroundColor(colorTheme, brightness),
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: isLight 
              ? primaryColor.withValues(alpha: 0.12)
              : primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      titleTextStyle: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: _getDialogTextColor(brightness),
        height: 1.2,
      ),
      contentTextStyle: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: _getDialogTextColor(brightness).withValues(alpha: 0.8),
        height: 1.4,
      ),
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      insetPadding: const EdgeInsets.all(24),
    );
  }

  /// 获取对话框背景颜色
  /// 
  /// 使用主题色的浅色版本作为背景，确保与主题一致但不会影响文字可读性
  static Color _getDialogBackgroundColor(AppColorTheme colorTheme, Brightness brightness) {
    final primaryColor = ColorThemeConfig.getPrimaryColor(colorTheme);
    
    if (brightness == Brightness.light) {
      // 亮色主题：使用白色背景，添加主题色调
      return Color.lerp(
        const Color(0xFFFFFBFE), // 基础白色
        primaryColor,
        0.02, // 非常浅的主题色调
      )!;
    } else {
      // 暗色主题：使用深色背景，添加主题色调
      return Color.lerp(
        const Color(0xFF1C1B1F), // 基础深色
        primaryColor,
        0.08, // 较浅的主题色调
      )!;
    }
  }

  /// 获取对话框文字颜色
  /// 
  /// 确保文字始终清晰可读
  static Color _getDialogTextColor(Brightness brightness) {
    return brightness == Brightness.light
        ? const Color(0xFF1C1B1F) // 亮色主题使用深色文字
        : const Color(0xFFE6E0E9); // 暗色主题使用浅色文字
  }

  /// 获取对话框按钮颜色配置
  /// 
  /// 为对话框中的按钮提供统一的颜色方案
  static ButtonThemeData getDialogButtonTheme(AppColorTheme colorTheme, Brightness brightness) {
    final primaryColor = ColorThemeConfig.getPrimaryColor(colorTheme);
    final textColor = _getDialogTextColor(brightness);
    
    return ButtonThemeData(
      textTheme: ButtonTextTheme.primary,
      buttonColor: primaryColor.withValues(alpha: 0.1),
      disabledColor: textColor.withValues(alpha: 0.3),
    );
  }

  /// 获取针对特定主题的AlertDialog样式
  /// 
  /// 提供便捷方法为AlertDialog应用正确的样式
  static AlertDialog createThemedAlertDialog({
    required BuildContext context,
    required AppColorTheme colorTheme,
    Widget? title,
    Widget? content,
    List<Widget>? actions,
    bool scrollable = false,
  }) {
    final brightness = Theme.of(context).brightness;
    final backgroundColor = _getDialogBackgroundColor(colorTheme, brightness);
    final textColor = _getDialogTextColor(brightness);
    final primaryColor = ColorThemeConfig.getPrimaryColor(colorTheme);
    
    return AlertDialog(
      backgroundColor: backgroundColor,
      surfaceTintColor: Colors.transparent,
      elevation: 8,
      shadowColor: Colors.black.withValues(alpha: 0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: brightness == Brightness.light 
              ? primaryColor.withValues(alpha: 0.12)
              : primaryColor.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      title: title != null ? DefaultTextStyle(
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: textColor,
          height: 1.2,
        ),
        child: title,
      ) : null,
      content: content != null ? DefaultTextStyle(
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          color: textColor.withValues(alpha: 0.8),
          height: 1.4,
        ),
        child: content,
      ) : null,
      actions: actions,
      scrollable: scrollable,
      actionsPadding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
      insetPadding: const EdgeInsets.all(24),
    );
  }

  /// 获取对话框装饰渐变背景（可选）
  /// 
  /// 为特殊对话框提供渐变背景选项
  static BoxDecoration getGradientDialogDecoration(AppColorTheme colorTheme, Brightness brightness) {
    final primaryColor = ColorThemeConfig.getPrimaryColor(colorTheme);
    final backgroundColor = _getDialogBackgroundColor(colorTheme, brightness);
    
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          backgroundColor,
          Color.lerp(backgroundColor, primaryColor, 0.03)!,
        ],
        stops: const [0.0, 1.0],
      ),
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: brightness == Brightness.light 
            ? primaryColor.withValues(alpha: 0.12)
            : primaryColor.withValues(alpha: 0.3),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 16,
          offset: const Offset(0, 4),
          spreadRadius: -2,
        ),
        BoxShadow(
          color: primaryColor.withValues(alpha: 0.08),
          blurRadius: 8,
          offset: const Offset(0, 2),
          spreadRadius: 0,
        ),
      ],
    );
  }

  /// 为现有的AlertDialog包装主题样式
  /// 
  /// 这个方法可以用来快速将现有的AlertDialog转换为主题化版本
  static Widget wrapWithTheme({
    required BuildContext context,
    required AppColorTheme colorTheme,
    required AlertDialog dialog,
  }) {
    final brightness = Theme.of(context).brightness;
    final textColor = _getDialogTextColor(brightness);
    
    return Theme(
      data: Theme.of(context).copyWith(
        dialogTheme: getDialogTheme(colorTheme, brightness),
        textTheme: Theme.of(context).textTheme.copyWith(
          titleLarge: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textColor,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: textColor.withValues(alpha: 0.8),
          ),
        ),
      ),
      child: dialog,
    );
  }
}
