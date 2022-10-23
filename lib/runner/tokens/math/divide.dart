part of arrow_tokens;

class ArrowDivideToken extends ArrowToken {
  ArrowToken left;
  ArrowToken right;

  ArrowDivideToken(this.left, this.right, super.vm, super.file, super.line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return {...left.dependencies(toIgnore), ...right.dependencies(toIgnore)}.toList();
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final l = left.get(locals, globals, stackTrace);
    final r = right.get(locals, globals, stackTrace);

    stackTrace.push(ArrowStackTraceElement("Divide", file, line));
    final result = l.divide(r, stackTrace, file, line);
    stackTrace.pop();

    return result;
  }

  @override
  String get name => "divide";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    get(locals, globals, stackTrace);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    get(locals, globals, stackTrace);
  }
}
