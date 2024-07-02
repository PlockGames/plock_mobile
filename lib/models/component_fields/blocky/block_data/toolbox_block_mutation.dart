import 'package:plock_mobile/models/component_fields/blocky/block_data/toolbox_block_data.dart';

/// A mutation in a block.
class ToolboxBlockMutation extends ToolboxBlockData {
  // list of all the differents mutators
  final bool? divisor_input;
  final String? op;
  final bool? at;
  final bool? at1;
  final bool? at2;
  final String? items;
  final String? type;
  final bool? statement;
  final String? mode;

  ToolboxBlockMutation({
    this.divisor_input,
    this.op,
    this.at,
    this.items,
    this.at2,
    this.at1,
    this.type,
    this.statement,
    this.mode,
  });

  factory ToolboxBlockMutation.fromJson(Map<String, dynamic> json) {
    return ToolboxBlockMutation(
      divisor_input: json['divisor_input'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'divisor_input': divisor_input,
    };
  }

  @override
  String getXml() {
    String result = '<mutation ';

    if (divisor_input != null) {
      result += 'divisor_input="${divisor_input! ? 'true' : 'false'}" ';
    }

    if (op != null) {
      result += 'op="$op" ';
    }

    if (at != null) {
      result += 'at="${at! ? 'true' : 'false'}" ';
    }

    if (at1 != null) {
      result += 'at1="${at1! ? 'true' : 'false'}" ';
    }

    if (at2 != null) {
      result += 'at2="${at2! ? 'true' : 'false'}" ';
    }

    if (items != null) {
      result += 'items="$items" ';
    }

    if (type != null) {
      result += 'type="$type" ';
    }

    if (statement != null) {
      result += 'statement="${statement! ? 'true' : 'false'}" ';
    }

    if (mode != null) {
      result += 'mode="$mode" ';
    }

    result += '></mutation>';
    return result;
  }
}