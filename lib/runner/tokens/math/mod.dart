part of arrow_tokens;

class ArrowModToken extends ArrowToken {
  ArrowToken left;
  ArrowToken right;

  ArrowModToken(this.left, this.right, super.vm, super.file, super.line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return {...left.dependencies(toIgnore), ...right.dependencies(toIgnore)}.toList();
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final l = left.get(locals, globals, stackTrace);
    final r = right.get(locals, globals, stackTrace);

    stackTrace.push(ArrowStackTraceElement("Modulus", file, line));
    final result = l.mod(r, stackTrace, file, line);
    stackTrace.pop();

    return result;
  }

  @override
  String get name => "mod";

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
      if (oleft.n == 0 && oright.n == 0) return ArrowNumberToken(double.nan, vm, file, line);
      if (oright.n == 0) return ArrowNumberToken(oleft.n.isNegative ? double.negativeInfinity : double.infinity, vm, file, line);
      if (oright.n == double.nan) return ArrowNumberToken(double.nan, vm, file, line);
      if (oleft.n == double.nan) return ArrowNumberToken(double.nan, vm, file, line);

      return ArrowNumberToken(oleft.n % oright.n, vm, file, line);
    }

    return ArrowAdditionToken(oleft, oright, vm, file, line);
  }
}
