part of arrow_tokens;

class ArrowSetToken extends ArrowToken {
  ArrowToken varname;
  ArrowToken value;

  ArrowSetToken(this.varname, this.value, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    final d = value.dependencies(toIgnore);

    return [...d, ...varname.dependencies(toIgnore)];
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return ArrowNull();
  }

  @override
  String get name => "arrow:set($varname, ${value.name})";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final val = value.get(locals, globals, stackTrace);
    varname.set(locals, globals, stackTrace, val);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
  }

  @override
  ArrowToken get optimized => ArrowSetToken(varname.optimized, value.optimized, vm, file, line);
}
