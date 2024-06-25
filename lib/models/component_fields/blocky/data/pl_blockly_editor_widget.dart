import 'package:flutter/material.dart';
import 'package:flutter_blockly/flutter_blockly.dart';
import 'package:plock_mobile/models/component_fields/blocky/data/pl_blockly_editor.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PlBlocklyEditorWidget extends StatefulWidget {
  /// [BlocklyOptions interface](https://developers.google.com/blockly/reference/js/blockly.blocklyoptions_interface)
  final BlocklyOptions? workspaceConfiguration;

  /// Blockly initial state (xml string or json)
  final dynamic initial;

  /// It is called on any error
  final Function? onError;

  /// It is called on inject editor
  final Function? onInject;

  /// It is called on change editor sate
  final Function? onChange;

  /// It is called on dispose editor
  final Function? onDispose;

  // Blocky packages
  final String? packages;

  // Blocky scripts
  final String? scripts;

  final String? blocks;

  const PlBlocklyEditorWidget({
    super.key,
    this.workspaceConfiguration,
    this.initial,
    this.onError,
    this.onInject,
    this.onChange,
    this.onDispose,
    this.packages,
    this.scripts,
    this.blocks,
  });

  @override
  State<PlBlocklyEditorWidget> createState() => _PlBlocklyEditorWidgetState();

}

class _PlBlocklyEditorWidgetState extends State<PlBlocklyEditorWidget> {
  late final PlBlocklyEditor editor;

  @override
  void initState() {
    super.initState();

    /// Create new BlocklyEditor
    editor = PlBlocklyEditor(
      workspaceConfiguration: widget.workspaceConfiguration,
      initial: widget.initial,
      onError: widget.onError,
      onInject: widget.onInject,
      onChange: widget.onChange,
      onDispose: widget.onDispose,
    );

    String htmlString = editor.htmlRender(packages: widget.packages, script: widget.scripts, blocks: widget.blocks);
    /// Configuration the WebViewController
    editor.blocklyController
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            editor.init();
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..addJavaScriptChannel(
        'FlutterWebView',
        onMessageReceived: editor.onMessage,
      )
      ..loadHtmlString(htmlString);
  }

  @override
  void dispose() {
    super.dispose();
    editor.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(
      controller: editor.blocklyController,
    );
  }
}