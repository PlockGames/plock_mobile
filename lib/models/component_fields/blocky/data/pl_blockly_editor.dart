import 'package:flutter_blockly/flutter_blockly.dart';
import "html/html.dart" as html;

/// A Blockly editor.
class PlBlocklyEditor extends BlocklyEditor {

  PlBlocklyEditor({
    workspaceConfiguration,
    initial,
    onError,
    onInject,
    onChange,
    onDispose,
  }) :
    super(
    workspaceConfiguration: workspaceConfiguration,
    initial: initial,
    onError: onError,
    onInject: onInject,
    onChange: onChange,
    onDispose: onDispose
  );

  @override
  String htmlRender({
    String? style,
    String? script,
    String? editor,
    String? packages,
    String? blocks,
  }) {
    return html.htmlRender(
      style: html.htmlStyle(style: style),
      script: html.htmlScript(script: script, blocks: blocks),
      editor: editor ?? html.htmlEditor(),
      packages: html.htmlPackages(packages: packages),
    );
  }
}