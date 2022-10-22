part of arrow_tokens;

class ArrowBoolToken extends ArrowToken {
  bool boolean;

  ArrowBoolToken(this.boolean, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) => [];

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return ArrowBool(boolean);
  }

  @override
  String get name => "bool($boolean)";

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }
}
