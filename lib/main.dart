import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'screens/webview_screen.dart';
import 'services/webview_service.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Pre-warm the WebView controller and start loading immediately
  WebViewService.instance.init();

  // Set status bar styling to match app theme
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.white,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const TuidApp());
}

class TuidApp extends StatelessWidget {
  const TuidApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TUİD',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF313B45),
          primary: const Color(0xFF313B45),
          secondary: const Color(0xFF4DB2EC),
          surface: Colors.white,
        ),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Color(0xFF313B45),
        ),
      ),
      home: const WebViewScreen(),
    );
  }
}
