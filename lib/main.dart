import 'package:flutter/material.dart';
import 'package:tipple_drinks/widgets/app_bg.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TippleApp());
}

class TippleApp extends StatelessWidget {
  const TippleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Tipple Drinks',
      theme: ThemeData(
        primaryColor: const Color(0xFFDF422A),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFDF422A),
          foregroundColor: Colors.white,
        ),
      ),
      home: const WebViewScreen(),
    );
  }
}

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  double progress = 0;

  @override
  void initState() {
    super.initState();

    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.white)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (p) {
            if (mounted) {
              setState(() {
                progress = p / 100;
              });
            }
          },
          onWebResourceError: (error) {
            debugPrint('WebView error: ${error.description}');
          },
        ),
      )
      ..loadRequest(Uri.parse('https://web.tippledrinks.com/version-test'));
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: Scaffold(
          body: Stack(
            children: [
              WebViewWidget(controller: _controller),
              if (progress < 1)
                LinearProgressIndicator(
                  value: progress,
                  color: const Color(0xFFDF422A),
                  backgroundColor: Colors.white,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
