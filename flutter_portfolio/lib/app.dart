import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'data/portfolio_data.dart';
import 'pages/home_page.dart';
import 'theme/app_theme.dart';

class PortfolioApp extends StatefulWidget {
  const PortfolioApp({super.key});

  @override
  State<PortfolioApp> createState() => _PortfolioAppState();
}

class _PortfolioAppState extends State<PortfolioApp> {
  ThemeMode _mode = ThemeMode.dark;

  void _toggleTheme() {
    setState(() {
      _mode = _mode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool isDark = _mode == ThemeMode.dark;
    return MaterialApp(
      title: '${profile.name} - ${profile.role}',
      debugShowCheckedModeBanner: false,
      scrollBehavior: const AppScrollBehavior(),
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: _mode,
      home: HomePage(isDark: isDark, onToggleTheme: _toggleTheme),
    );
  }
}

/// Lets the page be dragged with a mouse / trackpad, not just the wheel.
class AppScrollBehavior extends MaterialScrollBehavior {
  const AppScrollBehavior();

  @override
  Set<PointerDeviceKind> get dragDevices => <PointerDeviceKind>{
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
        PointerDeviceKind.trackpad,
        PointerDeviceKind.stylus,
      };
}
