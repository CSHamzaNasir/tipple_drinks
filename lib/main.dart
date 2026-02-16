// import 'package:flutter/material.dart';
// import 'package:tipple_drinks/widgets/app_bg.dart';
// import 'package:webview_flutter/webview_flutter.dart';

// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(const TippleApp());
// }

// class TippleApp extends StatelessWidget {
//   const TippleApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Tipple Drinks',
//       theme: ThemeData(
//         primaryColor: const Color(0xFFDF422A),
//         scaffoldBackgroundColor: Colors.white,
//         appBarTheme: const AppBarTheme(
//           backgroundColor: Color(0xFFDF422A),
//           foregroundColor: Colors.white,
//         ),
//       ),
//       home: const WebViewScreen(),
//     );
//   }
// }

// class WebViewScreen extends StatefulWidget {
//   const WebViewScreen({super.key});

//   @override
//   State<WebViewScreen> createState() => _WebViewScreenState();
// }

// class _WebViewScreenState extends State<WebViewScreen> {
//   late final WebViewController _controller;
//   double progress = 0;

//   @override
//   void initState() {
//     super.initState();

//     _controller = WebViewController()
//       ..setJavaScriptMode(JavaScriptMode.unrestricted)
//       ..setBackgroundColor(Colors.white)
//       ..setUserAgent(
//         "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36",
//       )
//       ..setNavigationDelegate(
//         NavigationDelegate(
//           onProgress: (p) {
//             if (mounted) {
//               setState(() {
//                 progress = p / 100;
//               });
//             }
//           },
//           onWebResourceError: (error) {
//             debugPrint('WebView error: ${error.description}');
//           },
//           onNavigationRequest: (NavigationRequest request) {
//             return NavigationDecision.navigate;
//           },
//         ),
//       )
//       ..loadRequest(Uri.parse('https://web.tippledrinks.com/version-live'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AppBackground(
//       child: SafeArea(
//         child: WillPopScope(
//           onWillPop: () async {
//             if (await _controller.canGoBack()) {
//               _controller.goBack();
//               return false;
//             }
//             return true;
//           },
//           child: Scaffold(
//             body: Stack(
//               children: [
//                 WebViewWidget(controller: _controller),
//                 if (progress < 1)
//                   LinearProgressIndicator(
//                     value: progress,
//                     color: const Color(0xFFDF422A),
//                     backgroundColor: Colors.white,
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
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
      ..setUserAgent(
        "Mozilla/5.0 (Linux; Android 10; K) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/122.0.0.0 Mobile Safari/537.36",
      )
      ..setOnJavaScriptAlertDialog((request) async {
        await _showJsAlert(request.message);
      })
      ..setOnJavaScriptConfirmDialog((request) async {
        return await _showJsConfirm(request.message);
      })
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
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse('https://web.tippledrinks.com/version-live'));
  }

  // --- DIALOGUE HELPER METHODS ---

  Future<void> _showJsAlert(String message) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Alert',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          content: Text(
            message,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
          ),
          actions: <Widget>[
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 55),
                backgroundColor: const Color(0xFFDF422A),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text('OK', style: TextStyle(color: Colors.white)),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }

  Future<bool> _showJsConfirm(String message) async {
    final bool? result = await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: const Text(
            'Confirm',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          content: Text(message, style: const TextStyle(fontSize: 16)),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(false),
            ),
            TextButton(
              child: const Text('OK', style: TextStyle(color: Colors.black)),
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        );
      },
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AppBackground(
      child: SafeArea(
        child: PopScope(
          canPop: false,
          onPopInvokedWithResult: (didPop, result) async {
            if (didPop) return;
            if (await _controller.canGoBack()) {
              _controller.goBack();
            } else {
              if (context.mounted) Navigator.of(context).pop();
            }
          },
          child: Scaffold(
            body: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                FocusScope.of(context).unfocus();
                if (Navigator.canPop(context)) {
                  Navigator.of(context).pop();
                }
              },
              child: Stack(
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
        ),
      ),
    );
  }
}
