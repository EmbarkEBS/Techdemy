import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CodeEditorPage extends StatefulWidget {
  const CodeEditorPage({super.key});

  @override
  State<CodeEditorPage> createState() => _CodeEditorPageState();
}

class _CodeEditorPageState extends State<CodeEditorPage> {
  late WebViewController _controller;
  late final PlatformWebViewControllerCreationParams params;
  @override
  void initState() {
    super.initState();
    final WebViewController controller = WebViewController.fromPlatformCreationParams(params);
    controller
      ..loadRequest(Uri.parse('https://www.jdoodle.com/execute-dart-online'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
  
    // #enddocregion platform_features

    _controller = controller;
  }

  Future<bool> _exitApp(BuildContext context) async {
    if (await _controller.canGoBack()) {
      debugPrint("onwill goback");
      _controller.goBack();
      return Future.value(true);
    } else {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No back history item")),
      );
      return Future.value(false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) => _exitApp,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('Code Editor'),
          ),
          body: SafeArea(child: WebViewWidget(controller: _controller)
        )
      ),
    );
  }
}
