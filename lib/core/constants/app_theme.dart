import 'package:flutter/material.dart';

class AppTheme {
  // 基于图标的温暖色彩方案
  static const Color primaryOrange = Color(0xFFE8A87C); // 主橙色
  static const Color secondaryOrange = Color(0xFFD4956B); // 次橙色
  static const Color accentOrange = Color(0xFFF4B183); // 强调橙色
  static const Color warmCream = Color(0xFFFAF3E8); // 温暖奶油色
  static const Color lightCream = Color(0xFFFDF8F0); // 浅奶油色
  static const Color richBrown = Color(0xFF8B4513); // 丰富棕色
  static const Color darkBrown = Color(0xFF654321); // 深棕色
  static const Color softGray = Color(0xFFF5F1EB); // 柔和灰色

  // 功能色彩
  static const Color successGreen = Color(0xFF7FB069);
  static const Color warningAmber = Color(0xFFE8A87C);
  static const Color errorRed = Color(0xFFD4756B);
  static const Color infoBlue = Color(0xFF7BA7BC);

  static final ColorScheme lightColorScheme = ColorScheme.light(
    primary: primaryOrange,
    primaryContainer: warmCream,
    onPrimaryContainer: darkBrown,
    secondary: secondaryOrange,
    secondaryContainer: lightCream,
    onSecondaryContainer: richBrown,
    surface: lightCream,
    onSurface: darkBrown,
    surfaceContainerHighest: softGray,
    background: warmCream,
    onBackground: darkBrown,
    error: errorRed,
    onError: Colors.white,
    outline: primaryOrange.withOpacity(0.3),
  );

  static final ColorScheme darkColorScheme = ColorScheme.dark(
    primary: accentOrange,
    primaryContainer: darkBrown,
    onPrimaryContainer: warmCream,
    secondary: secondaryOrange,
    secondaryContainer: richBrown,
    onSecondaryContainer: lightCream,
    surface: const Color(0xFF2C1810),
    onSurface: warmCream,
    surfaceContainerHighest: const Color(0xFF3D2418),
    background: const Color(0xFF1F1209),
    onBackground: warmCream,
    error: errorRed,
    onError: Colors.white,
    outline: accentOrange.withOpacity(0.3),
  );

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: lightColorScheme,
    fontFamily: 'Georgia', // 使用衬线字体增加文学感

    // AppBar 主题 - 温暖渐变
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: darkBrown,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: const TextStyle(
        color: darkBrown,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        fontFamily: 'Georgia',
      ),
      iconTheme: const IconThemeData(color: darkBrown),
    ),

    // 卡片主题 - 温暖圆润
    cardTheme: CardTheme(
      color: lightCream,
      shadowColor: primaryOrange.withOpacity(0.2),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    // 按钮主题 - 温暖风格
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 6,
        shadowColor: primaryOrange.withOpacity(0.4),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Georgia',
        ),
      ),
    ),

    outlinedButtonTheme: OutlinedButtonThemeData(
      style: OutlinedButton.styleFrom(
        foregroundColor: primaryOrange,
        side: BorderSide(color: primaryOrange, width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Georgia',
        ),
      ),
    ),

    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: primaryOrange,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        textStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          fontFamily: 'Georgia',
        ),
      ),
    ),

    // 输入框主题 - 温暖边框
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: lightCream,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryOrange.withOpacity(0.3)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: primaryOrange, width: 2),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(color: primaryOrange.withOpacity(0.3)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: errorRed),
      ),
      contentPadding: const EdgeInsets.all(20),
      hintStyle: TextStyle(
        color: richBrown.withOpacity(0.6),
        fontSize: 16,
        fontFamily: 'Georgia',
      ),
      labelStyle: const TextStyle(
        color: richBrown,
        fontSize: 16,
        fontFamily: 'Georgia',
      ),
    ),

    // 浮动操作按钮主题
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: primaryOrange,
      foregroundColor: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // 文字主题 - 温暖可读
    textTheme: TextTheme(
      headlineLarge: TextStyle(
        color: darkBrown,
        fontSize: 32,
        fontWeight: FontWeight.bold,
        height: 1.2,
        fontFamily: 'Georgia',
        shadows: [
          Shadow(
            offset: const Offset(1, 1),
            blurRadius: 2,
            color: primaryOrange.withOpacity(0.3),
          ),
        ],
      ),
      headlineMedium: const TextStyle(
        color: darkBrown,
        fontSize: 28,
        fontWeight: FontWeight.bold,
        height: 1.3,
        fontFamily: 'Georgia',
      ),
      headlineSmall: const TextStyle(
        color: darkBrown,
        fontSize: 24,
        fontWeight: FontWeight.w600,
        height: 1.3,
        fontFamily: 'Georgia',
      ),
      titleLarge: const TextStyle(
        color: darkBrown,
        fontSize: 20,
        fontWeight: FontWeight.w600,
        height: 1.4,
        fontFamily: 'Georgia',
      ),
      titleMedium: const TextStyle(
        color: darkBrown,
        fontSize: 18,
        fontWeight: FontWeight.w600,
        height: 1.4,
        fontFamily: 'Georgia',
      ),
      titleSmall: const TextStyle(
        color: darkBrown,
        fontSize: 16,
        fontWeight: FontWeight.w600,
        height: 1.4,
        fontFamily: 'Georgia',
      ),
      bodyLarge: const TextStyle(
        color: darkBrown,
        fontSize: 16,
        height: 1.6,
        fontFamily: 'Georgia',
      ),
      bodyMedium: const TextStyle(
        color: darkBrown,
        fontSize: 14,
        height: 1.5,
        fontFamily: 'Georgia',
      ),
      bodySmall: TextStyle(
        color: richBrown.withOpacity(0.8),
        fontSize: 12,
        height: 1.4,
        fontFamily: 'Georgia',
      ),
    ),

    // Chip 主题
    chipTheme: ChipThemeData(
      backgroundColor: warmCream,
      selectedColor: primaryOrange,
      labelStyle: const TextStyle(
        color: darkBrown,
        fontFamily: 'Georgia',
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: darkColorScheme,
    fontFamily: 'Georgia',
    
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.transparent,
      foregroundColor: warmCream,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleTextStyle: const TextStyle(
        color: warmCream,
        fontSize: 22,
        fontWeight: FontWeight.w600,
        fontFamily: 'Georgia',
      ),
      iconTheme: const IconThemeData(color: warmCream),
    ),

    cardTheme: CardTheme(
      color: const Color(0xFF2C1810),
      shadowColor: accentOrange.withOpacity(0.3),
      elevation: 6,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    ),

    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  // 自定义装饰
  static BoxDecoration get warmGradientDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: [
        primaryOrange,
        secondaryOrange,
        accentOrange,
      ],
      stops: const [0.0, 0.5, 1.0],
    ),
  );

  static BoxDecoration get subtleGradientDecoration => BoxDecoration(
    gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        lightCream,
        warmCream,
      ],
    ),
  );

  // 阴影效果
  static List<BoxShadow> get warmShadow => [
    BoxShadow(
      color: primaryOrange.withOpacity(0.2),
      blurRadius: 8,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: Colors.black.withOpacity(0.1),
      blurRadius: 6,
      offset: const Offset(0, 2),
    ),
  ];
}
