part of arrow_tokens;

class ArrowNullToken extends ArrowToken {
  ArrowNullToken(ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) => [];

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return ArrowNull();
  }

  @override
  String get name => "null";

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }
}
