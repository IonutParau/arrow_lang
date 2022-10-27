part of arrow_tokens;

class ArrowCallToken extends ArrowToken {
  List<ArrowToken> params;
  ArrowToken toCall;

  ArrowCallToken(this.params, this.toCall, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    final pd = <String>{};

    for (var param in params) {
      pd.addAll(param.dependencies(toIgnore));
    }

    return {...toCall.dependencies(toIgnore), ...pd}.toList();
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
