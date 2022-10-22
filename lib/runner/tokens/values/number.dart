part of arrow_tokens;

class ArrowNumberToken extends ArrowToken {
  double n;

  ArrowNumberToken(this.n, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) => [];

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return ArrowNumber(n);
  }

  @override
  String get name => "number($n)";

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }
}
