import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    useMaterial3: true, // Good to have this explicitly
    fontFamily: 'Roboto',

    // Color Scheme - M3 compatible
    colorScheme: ColorScheme.light(
      primary: Color(0xFF1E88E5),       // Primary blue
      // primaryVariant: Color(0xFF1976D2), // M2: Removed for M3
      secondary: Color(0xFF64B5F6),      // Lighter blue
      // secondaryVariant: Color(0xFF42A5F5), // M2: Removed for M3
      surface: Colors.white,
      background: Color(0xFFF5F5F5),     // Light grey background
      error: Color(0xFFE53935),          // Error red
      onPrimary: Colors.white,           // Text/icon on primary
      onSecondary: Colors.black87,       // Text/icon on secondary
      onSurface: Colors.black87,         // Default text color
      onBackground: Colors.black87,
      onError: Colors.white,
      // You might want to define container colors if needed for M3 components
      // primaryContainer: Color(0xFFD1E6FF), // Example: light blue for containers
      // onPrimaryContainer: Color(0xFF001E3C), // Example: text on primaryContainer
    ),

    // App Bar Theme
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E88E5), // or use colorScheme.primary
      elevation: 2,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.white, // or use colorScheme.onPrimary
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto', // Ensure font family is propagated
      ),
      iconTheme: IconThemeData(color: Colors.white), // or use colorScheme.onPrimary
    ),

    // Text Theme - M3 names
    textTheme: TextTheme(
      // M2 headline4 -> M3 headlineMedium or headlineSmall
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.black87),
      // M2 headline5 -> M3 titleLarge or headlineSmall
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.black87),
      // M2 headline6 -> M3 titleMedium
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.black87),
      // M2 subtitle1 -> M3 titleSmall or bodyLarge
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
      // M2 bodyText1 -> M3 bodyLarge
      bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
      // M2 bodyText2 -> M3 bodyMedium
      bodyMedium: TextStyle(fontSize: 14, color: Colors.black87),
      // M2 button -> M3 labelLarge
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500), // Often used for button text
      // M2 caption -> M3 bodySmall or labelSmall
      bodySmall: TextStyle(fontSize: 12, color: Colors.black87),
    ).apply(
      // Apply default text colors based on scheme if not specified above
      bodyColor: Colors.black87, // colorScheme.onSurface,
      displayColor: Colors.black87, // colorScheme.onSurface,
    ),

    // Button Themes
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF1E88E5), // M3: Use backgroundColor
        foregroundColor: Colors.white, // M3: Use foregroundColor for text/icon
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto'
        ),
      ),
    ),

    // Input Decoration Theme
    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[400]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF1E88E5), width: 2), // or use colorScheme.primary
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      // Consider setting filled: true and fillColor if you want a background for TextFields
    ),

    // Card Theme
    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      margin: EdgeInsets.all(8),
      // color: Colors.white, // Or colorScheme.surface
    ),

    // Other Properties
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );

  static ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    fontFamily: 'Roboto',
    brightness: Brightness.dark, // Important for dark theme

    colorScheme: ColorScheme.dark(
      primary: Color(0xFF90CAF9),      // Light blue for primary in dark
      // primaryVariant: Color(0xFF64B5F6), // M2: Removed
      secondary: Color(0xFF64B5F6),    // Another light blue for secondary
      // secondaryVariant: Color(0xFF42A5F5),// M2: Removed
      surface: Color(0xFF1E1E1E), // Dark surface (slightly lighter than background)
      background: Color(0xFF121212),  // Very dark background
      error: Color(0xFFCF6679),        // Standard M3 dark error color
      onPrimary: Colors.black,         // Text on primary (e.g., button text)
      onSecondary: Colors.black,       // Text on secondary
      onSurface: Colors.white,         // Default text color on dark surface
      onBackground: Colors.white,      // Text on dark background
      onError: Colors.black,           // Text on error color
    ),

    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E), // or use colorScheme.surface
      elevation: 0, // Common for dark themes
      titleTextStyle: TextStyle(
        color: Colors.white, // or use colorScheme.onSurface
        fontSize: 20,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto',
      ),
      iconTheme: IconThemeData(color: Colors.white), // or use colorScheme.onSurface
    ),

    textTheme: TextTheme(
      headlineMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
      titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
      titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w500, color: Colors.white),
      titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      bodyLarge: TextStyle(fontSize: 16, color: Colors.white),
      bodyMedium: TextStyle(fontSize: 14, color: Colors.white),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
      bodySmall: TextStyle(fontSize: 12, color: Colors.white),
    ).apply(
      bodyColor: Colors.white, // colorScheme.onSurface,
      displayColor: Colors.white, // colorScheme.onSurface,
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF90CAF9), // colorScheme.primary
        foregroundColor: Colors.black,    // colorScheme.onPrimary
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        textStyle: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            fontFamily: 'Roboto'
        ),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey[700]!),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Color(0xFF90CAF9), width: 2), // or colorScheme.primary
      ),
      contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      hintStyle: TextStyle(color: Colors.grey[500]),
      // filled: true,
      // fillColor: Color(0xFF2C2C2C), // Slightly lighter than surface for contrast
    ),

    cardTheme: CardTheme(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: Color(0xFF1E1E1E), // or colorScheme.surface
      margin: EdgeInsets.all(8),
    ),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}