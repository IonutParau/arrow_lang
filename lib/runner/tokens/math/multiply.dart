part of arrow_tokens;

class ArrowMultiplyToken extends ArrowToken {
  ArrowToken left;
  ArrowToken right;

  ArrowMultiplyToken(this.left, this.right, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return {...left.dependencies(toIgnore), ...right.dependencies(toIgnore)}.toList();
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final l = left.get(locals, globals, stackTrace);
    final r = right.get(locals, globals, stackTrace);

    stackTrace.push(ArrowStackTraceElement("Multiply", file, line));
    final result = l.multiply(r, stackTrace, file, line);
    stackTrace.pop();

    return result;
  }

  @override
  String get name => "multiply";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    get(locals, globals, stackTrace);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    get(locals, globals, stackTrace);
  }

  @override
  ArrowToken get optimized {
    final oleft = left.optimized;
    final oright = right.optimized;

    if (oleft is ArrowNumberToken && oright is ArrowNumberToken) {
      return ArrowNumberToken(oleft.n * oright.n, vm, file, line);
    }

    return ArrowAdditionToken(oleft, oright, vm, file, line);
  }
}
