part of arrow_tokens;

class ArrowCallToken extends ArrowToken {
  List<ArrowToken> params;
  ArrowToken toCall;

  ArrowCallToken(this.params, this.toCall, super.vm, super.file, super.line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return toCall.dependencies(toIgnore);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    stackTrace.push(ArrowStackTraceElement(name, file, line));
    final func = toCall.get(locals, globals, stackTrace);
    final paramsList = params.map((p) => p.get(locals, globals, stackTrace)).toList();
    final value = func.call(paramsList, stackTrace, file, line);
    stackTrace.pop();
    return value;
  }

  @override
  String get name => "${toCall.name}(${params.map((e) => e.name).join(', ')})";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    get(locals, globals, stackTrace);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }

  @override
  ArrowToken get optimized {
    final oparams = params.map((e) => e.optimized).toList();
    final ocall = toCall.optimized;

    return ArrowCallToken(oparams, ocall, vm, file, line);
  }
}
