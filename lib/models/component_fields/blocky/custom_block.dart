
/// The arguments of the block for blockly.
class Arg {
    final String type;
    final String? name;
    final String? check;
    final String? align;
    final List<List<String>>? options;

    Arg({required this.type, this.name, this.check, this.align, this.options});

    factory Arg.fromJson(Map<String, dynamic> json) {
        return Arg(
            type: json['type'],
            name: json['name'],
            check: json['check'],
            align: json['align'],
            options: json['options'],
        );
    }

    Map<String, dynamic> toJson() {
      if (type == "input_dummy") {
        return {
          'type': type,
        };
      }

      if (type == "field_dropdown") {
        return {
          'type': type,
          'name': name,
          'options': options,
        };
      }

      return {
            'type': type,
            'name': name,
            'check': check,
            'align': align,
        };
    }
}

/// A custom block for blockly.
class CustomBlock {

  /// The type.
  final String type;
  /// The displayed message.
  final String message;
  /// A list of the different arguments.
  final List<Arg> args;
  /// The colour.
  final int colour;
  /// The tooltip of the block.
  final String tooltip;
  /// The url of the documentation of the block.
  final String helpUrl;
  /// Is there a top connection ?
  bool previousStatement = false;
  /// Is there a bottom connection ?
  bool nextStatement = false;
  /// Is the block a left connection ?
  ///
  /// Type of the output block
  String? output;
  /// Is the block an output block ?
  bool isOutput = false;
  /// The converted to lua code of the block.
  String functionLua = '';
  /// The converted to dart code of the block.
  String functionDart = '';
  /// The converted to javascript code of the block.
  String functionJs = '';
  /// The converted to python code of the block.
  String functionPython = '';
  /// The converted to php code of the block.
  String functionPhp = '';

  CustomBlock(
      {required this.type,
      required this.message,
      required this.args,
      required this.colour,
      required this.tooltip,
      required this.helpUrl,
      this.output,
      this.previousStatement=false,
      this.nextStatement=false
      });

  /// Convert a json to a [CustomBlock].
  factory CustomBlock.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>>? argsJson = json['args0'];
    List<Arg> args = [];
    if (argsJson != null) {
      args = (argsJson as List).map((e) => Arg.fromJson(e)).toList();
    }

    var cb = CustomBlock(
      type: json['type'],
      message: json['message0'],
      args: args,
      colour: json['colour'],
      tooltip: json['tooltip'],
      helpUrl: json['helpUrl'],
    );

    if (json.keys.contains("previousStatement")) {
      cb.previousStatement = true;
    }
    if (json.keys.contains("nextStatement")) {
      cb.nextStatement = true;
    }

    if (json.keys.contains("output")) {
      cb.output = json['output'];
      cb.isOutput = true;
    }

    return cb;
  }

  /// Set the lua function of the block.
  CustomBlock setFunctionLua(String function) {
    this.functionLua = function;
    return this;
  }

  /// Get the lua function of the block.
  String getFunctionLua() {
    return this.functionLua;
  }

  /// Set the dart function of the block.
  CustomBlock setFunctionDart(String function) {
    this.functionDart = function;
    return this;
  }

  /// Get the dart function of the block.
  CustomBlock setFunctionJs(String function) {
    this.functionJs = function;
    return this;
  }

  /// Get the javascript function of the block.
  String getFunctionJs() {
    return this.functionJs;
  }

  /// Get the dart function of the block.
  String getFunctionDart() {
    return this.functionDart;
  }

  /// Set the python function of the block.
  CustomBlock setFunctionPython(String function) {
    this.functionPython = function;
    return this;
  }

  /// Get the python function of the block.
  String getFunctionPython() {
    return this.functionPython;
  }

  /// Set the php function of the block.
  CustomBlock setFunctionPhp(String function) {
    this.functionPhp = function;
    return this;
  }

  /// Get the php function of the block.
  String getFunctionPhp() {
    return this.functionPhp;
  }

  /// Convert the [CustomBlock] to a json.
  Map<String, dynamic> toJson() {
    var json = {
      'type': type,
      'message0': message,
      'colour': colour,
      'tooltip': tooltip,
      'helpUrl': helpUrl,
    };

    if (args.isNotEmpty) {
      json['args0'] = args.map((e) => e.toJson()).toList();
    }

    if (previousStatement) {
      json['previousStatement'] = 'null';
    }

    if (nextStatement) {
      json['nextStatement'] = 'null';
    }

    if (isOutput) {
      json['output'] = output ?? 'null';
    }

    return json;
  }
}