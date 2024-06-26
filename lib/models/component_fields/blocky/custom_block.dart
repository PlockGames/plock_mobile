class Arg {
    final String type;
    final String? name;
    final String? check;
    final String? align;

    Arg({required this.type, this.name, this.check, this.align});

    factory Arg.fromJson(Map<String, dynamic> json) {
        return Arg(
            type: json['type'],
            name: json['name'],
            check: json['check'],
            align: json['align'],
        );
    }

    Map<String, dynamic> toJson() {
      if (type == "input_dummy") {
        return {
          'type': type,
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

class CustomBlock {

  final String type;
  final String message;
  final List<Arg> args;
  final int colour;
  final String tooltip;
  final String helpUrl;
  bool previousStatement = false;
  bool nextStatement = false;
  String functionLua = '';
  String functionDart = '';
  String functionJs = '';
  String functionPython = '';
  String functionPhp = '';

  CustomBlock(
      {required this.type,
      required this.message,
      required this.args,
      required this.colour,
      required this.tooltip,
      required this.helpUrl,
      this.previousStatement=false,
      this.nextStatement=false
      });

  factory CustomBlock.fromJson(Map<String, dynamic> json) {

    var cb = CustomBlock(
      type: json['type'],
      message: json['message0'],
      args: (json['args0'] as List)
          .map((e) => Arg.fromJson(e))
          .toList(),
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

    return cb;
  }

  CustomBlock setFunctionLua(String function) {
    this.functionLua = function;
    return this;
  }

  String getFunctionLua() {
    return this.functionLua;
  }

  CustomBlock setFunctionDart(String function) {
    this.functionDart = function;
    return this;
  }

  CustomBlock setFunctionJs(String function) {
    this.functionJs = function;
    return this;
  }

  String getFunctionJs() {
    return this.functionJs;
  }

  String getFunctionDart() {
    return this.functionDart;
  }

  CustomBlock setFunctionPython(String function) {
    this.functionPython = function;
    return this;
  }

  String getFunctionPython() {
    return this.functionPython;
  }

  CustomBlock setFunctionPhp(String function) {
    this.functionPhp = function;
    return this;
  }

  String getFunctionPhp() {
    return this.functionPhp;
  }

  Map<String, dynamic> toJson() {
    var json = {
      'type': type,
      'message0': message,
      'args0': args.map((e) => e.toJson()).toList(),
      'colour': colour,
      'tooltip': tooltip,
      'helpUrl': helpUrl,
    };

    if (previousStatement) {
      json['previousStatement'] = 'null';
    }

    if (nextStatement) {
      json['nextStatement'] = 'null';
    }

    return json;
  }
}