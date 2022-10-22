part of arrow_tokens;

class ArrowStringToken extends ArrowToken {
  late String str;

  ArrowStringToken(String string, ArrowVM vm, String file, int line) : super(vm, file, line) {
    str = processed(string);
  }

  String processed(String string) {
    String str = "";
    final chars = string.split('');
    var lastChar = "";

    for (var char in chars) {
      if (char == "\\") {
        if (lastChar == "\\") {
          str += "\\";
          lastChar = "";
          continue;
        }
      } else {
        if (char == "n" && lastChar == "\\") {
          str += "\n";
          lastChar = "";
          continue;
        }
        if (char == "t" && lastChar == "\\") {
          str += "\t";
          lastChar = "";
          continue;
        }
        if (char == "\"" && lastChar == "\\") {
          str += "\"";
          lastChar = "";
          continue;
        }

        if (lastChar == "\\") {
          str += "\\";
        }
        str += char;
      }

      lastChar = char;
    }

    return str;
  }

  @override
  List<String> dependencies(List<String> toIgnore) => [];

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return ArrowString(str);
  }

  @override
  String get name => "string(\"$str\")";

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }
}
