import 'package:flutter/material.dart';
import 'color_theme.dart';

/// 聊天文字颜色主题配置类
/// 
/// 专门管理聊天界面中的文字颜色，确保：
/// 1. 用户消息文字在渐变背景上始终清晰可读
/// 2. AI消息文字根据主题亮暗度自适应
/// 3. 保持良好的对比度和可读性
/// 4. 模块化设计，易于维护
class ChatTextTheme {
  ChatTextTheme._();

  /// 获取用户消息的文字颜色
  /// 
  /// 用户消息使用渐变背景，文字颜色根据主题亮暗度自适应：
  /// - 浅色模式：黑色文字，在浅色渐变背景上清晰可读
  /// - 深色模式：白色文字，在深色渐变背景上清晰可读
  static Color getUserMessageTextColor(Brightness brightness) {
    return brightness == Brightness.light
        ? const Color(0xFF1C1B1F) // 浅色模式使用深色文字
        : Colors.white; // 深色模式使用白色文字
  }

  /// 获取AI消息的文字颜色
  /// 
  /// AI消息使用浅色背景，文字颜色需要根据主题亮暗度调整
  static Color getAIMessageTextColor(Brightness brightness) {
    return brightness == Brightness.light
        ? const Color(0xFF1C1B1F) // 亮色主题使用深色文字
        : const Color(0xFFE6E0E9); // 暗色主题使用浅色文字
  }

  /// 获取消息内容的文字颜色（用于MessageContentWidget）
  /// 
  /// [isFromUser] 是否是用户消息
  /// [brightness] 当前主题亮度
  static Color getMessageContentTextColor(bool isFromUser, Brightness brightness) {
    if (isFromUser) {
      return getUserMessageTextColor(brightness);
    } else {
      return getAIMessageTextColor(brightness);
    }
  }

  /// 获取强调文字颜色（标题、加粗等）
  /// 
  /// 用户消息和AI消息都根据主题亮度使用对比度更高的颜色
  static Color getEmphasisTextColor(bool isFromUser, Brightness brightness) {
    if (isFromUser) {
      return brightness == Brightness.light
          ? const Color(0xFF0D1117) // 浅色模式使用更深的黑色
          : const Color(0xFFF0F6FC); // 深色模式使用更亮的白色
    } else {
      return brightness == Brightness.light
          ? const Color(0xFF0D1117) // 更深的黑色
          : const Color(0xFFF0F6FC); // 更亮的白色
    }
  }

  /// 获取次要文字颜色（时间戳、辅助信息等）
  /// 
  /// 使用半透明效果来降低视觉权重
  static Color getSecondaryTextColor(bool isFromUser, Brightness brightness) {
    if (isFromUser) {
      final baseColor = getUserMessageTextColor(brightness);
      return baseColor.withValues(alpha: 0.8);
    } else {
      final baseColor = getAIMessageTextColor(brightness);
      return baseColor.withValues(alpha: 0.7);
    }
  }

  /// 获取代码块内文字颜色
  /// 
  /// 在代码块中需要确保语法高亮的可读性
  static Color getCodeTextColor(bool isFromUser, Brightness brightness) {
    if (isFromUser) {
      final baseColor = getUserMessageTextColor(brightness);
      return baseColor.withValues(alpha: 0.95);
    } else {
      return brightness == Brightness.light
          ? const Color(0xFF24292F) // GitHub light主题色
          : const Color(0xFFE6EDF3); // GitHub dark主题色
    }
  }

  /// 获取链接文字颜色
  /// 
  /// 链接需要有足够的对比度和可识别性
  static Color getLinkTextColor(bool isFromUser, Brightness brightness) {
    if (isFromUser) {
      return brightness == Brightness.light
          ? const Color(0xFF0969DA) // 浅色模式使用深蓝色
          : const Color(0xFFB3E5FC); // 深色模式使用浅蓝色
    } else {
      return brightness == Brightness.light
          ? const Color(0xFF0969DA) // GitHub链接色
          : const Color(0xFF58A6FF); // GitHub dark链接色
    }
  }

  /// 获取引用块文字颜色
  /// 
  /// 引用块需要与正文有所区分但仍保持可读性
  static Color getBlockquoteTextColor(bool isFromUser, Brightness brightness) {
    final baseColor = getMessageContentTextColor(isFromUser, brightness);
    return baseColor.withValues(alpha: 0.85);
  }

  /// 获取数学公式文字颜色
  /// 
  /// 数学公式需要清晰显示
  static Color getMathTextColor(bool isFromUser, Brightness brightness) {
    return getMessageContentTextColor(isFromUser, brightness);
  }

  /// 创建完整的TextStyle用于消息内容
  /// 
  /// 提供完整的文字样式配置，包括颜色、字体、行高等
  static TextStyle createMessageTextStyle({
    required bool isFromUser,
    required Brightness brightness,
    required TextStyle baseStyle,
    bool isEmphasis = false,
    bool isSecondary = false,
    bool isCode = false,
    bool isLink = false,
    bool isBlockquote = false,
  }) {
    Color textColor;
    
    if (isCode) {
      textColor = getCodeTextColor(isFromUser, brightness);
    } else if (isLink) {
      textColor = getLinkTextColor(isFromUser, brightness);
    } else if (isBlockquote) {
      textColor = getBlockquoteTextColor(isFromUser, brightness);
    } else if (isEmphasis) {
      textColor = getEmphasisTextColor(isFromUser, brightness);
    } else if (isSecondary) {
      textColor = getSecondaryTextColor(isFromUser, brightness);
    } else {
      textColor = getMessageContentTextColor(isFromUser, brightness);
    }

    return baseStyle.copyWith(color: textColor);
  }

  /// 为MarkdownStyleSheet提供颜色配置
  /// 
  /// 返回一个Map，包含Markdown各元素的颜色配置
  static Map<String, Color> getMarkdownColors({
    required bool isFromUser,
    required Brightness brightness,
  }) {
    return {
      'text': getMessageContentTextColor(isFromUser, brightness),
      'heading': getEmphasisTextColor(isFromUser, brightness),
      'code': getCodeTextColor(isFromUser, brightness),
      'link': getLinkTextColor(isFromUser, brightness),
      'blockquote': getBlockquoteTextColor(isFromUser, brightness),
      'emphasis': getEmphasisTextColor(isFromUser, brightness),
      'strong': getEmphasisTextColor(isFromUser, brightness),
    };
  }

  /// 检查颜色对比度是否足够
  /// 
  /// 用于验证文字颜色在背景上的可读性
  static bool hasGoodContrast(Color textColor, Color backgroundColor) {
    final luminance1 = textColor.computeLuminance();
    final luminance2 = backgroundColor.computeLuminance();
    
    final ratio = (luminance1 > luminance2)
        ? (luminance1 + 0.05) / (luminance2 + 0.05)
        : (luminance2 + 0.05) / (luminance1 + 0.05);
    
    return ratio >= 4.5; // WCAG AA标准
  }

  /// 为特定主题验证所有颜色配置
  /// 
  /// 开发时用于确保颜色配置的正确性
  static Map<String, bool> validateThemeColors(AppColorTheme theme, Brightness brightness) {
    final primaryColor = ColorThemeConfig.getPrimaryColor(theme);
    final userBgColor = primaryColor; // 用户消息背景（简化）
    final aiBgColor = brightness == Brightness.light 
        ? const Color(0xFFF5F5F5) 
        : const Color(0xFF2D2D2D); // AI消息背景（简化）

    return {
      'userText': hasGoodContrast(getUserMessageTextColor(brightness), userBgColor),
      'aiText': hasGoodContrast(getAIMessageTextColor(brightness), aiBgColor),
      'userCode': hasGoodContrast(getCodeTextColor(true, brightness), userBgColor),
      'aiCode': hasGoodContrast(getCodeTextColor(false, brightness), aiBgColor),
      'userLink': hasGoodContrast(getLinkTextColor(true, brightness), userBgColor),
      'aiLink': hasGoodContrast(getLinkTextColor(false, brightness), aiBgColor),
    };
  }
}

/// BuildContext扩展，提供便捷的聊天文字颜色访问
extension ChatTextThemeExtension on BuildContext {
  /// 获取当前主题下的聊天文字颜色配置
  ChatTextColors get chatTextColors {
    final brightness = Theme.of(this).brightness;
    return ChatTextColors(brightness: brightness);
  }
}

/// 聊天文字颜色配置类
/// 
/// 提供便捷的颜色访问方法
class ChatTextColors {
  final Brightness brightness;
  
  const ChatTextColors({required this.brightness});

  /// 用户消息文字颜色
  Color get userMessageText => ChatTextTheme.getUserMessageTextColor(brightness);
  
  /// AI消息文字颜色
  Color get aiMessageText => ChatTextTheme.getAIMessageTextColor(brightness);
  
  /// 获取消息文字颜色
  Color messageText(bool isFromUser) => 
      ChatTextTheme.getMessageContentTextColor(isFromUser, brightness);
  
  /// 获取强调文字颜色
  Color emphasisText(bool isFromUser) => 
      ChatTextTheme.getEmphasisTextColor(isFromUser, brightness);
  
  /// 获取次要文字颜色
  Color secondaryText(bool isFromUser) => 
      ChatTextTheme.getSecondaryTextColor(isFromUser, brightness);
  
  /// 获取代码文字颜色
  Color codeText(bool isFromUser) => 
      ChatTextTheme.getCodeTextColor(isFromUser, brightness);
  
  /// 获取链接文字颜色
  Color linkText(bool isFromUser) => 
      ChatTextTheme.getLinkTextColor(isFromUser, brightness);
  
  /// 获取引用文字颜色
  Color blockquoteText(bool isFromUser) => 
      ChatTextTheme.getBlockquoteTextColor(isFromUser, brightness);

  /// 创建消息文字样式
  TextStyle createTextStyle({
    required bool isFromUser,
    required TextStyle baseStyle,
    bool isEmphasis = false,
    bool isSecondary = false,
    bool isCode = false,
    bool isLink = false,
    bool isBlockquote = false,
  }) {
    return ChatTextTheme.createMessageTextStyle(
      isFromUser: isFromUser,
      brightness: brightness,
      baseStyle: baseStyle,
      isEmphasis: isEmphasis,
      isSecondary: isSecondary,
      isCode: isCode,
      isLink: isLink,
      isBlockquote: isBlockquote,
    );
  }

  /// 获取Markdown颜色配置
  Map<String, Color> getMarkdownColors(bool isFromUser) {
    return ChatTextTheme.getMarkdownColors(
      isFromUser: isFromUser,
      brightness: brightness,
    );
  }
}
