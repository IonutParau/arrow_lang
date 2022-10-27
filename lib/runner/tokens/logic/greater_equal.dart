part of arrow_tokens;

class ArrowGreaterEqualToken extends ArrowToken {
  ArrowToken left;
  ArrowToken right;

  ArrowGreaterEqualToken(this.left, this.right, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return {...left.dependencies(toIgnore), ...right.dependencies(toIgnore)}.toList();
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final l = left.get(locals, globals, stackTrace);
    final r = right.get(locals, globals, stackTrace);

    stackTrace.push(ArrowStackTraceElement("Greater Equal", file, line));
    final result = l.greaterEqual(r);
    stackTrace.pop();

    return ArrowBool(result);
  }

  @override
  String get name => "greaterEqual";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    get(locals, globals, stackTrace);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    get(locals, globals, stackTrace);
  }
}
