part of arrow_tokens;

class ArrowLetToken extends ArrowToken {
  String varname;
  ArrowToken value;

  ArrowLetToken(this.varname, this.value, super.vm, super.file, super.line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return value.dependencies(toIgnore);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return ArrowNull();
  }

  @override
  String get name => "arrow:let($varname, ${value.name})";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    locals.define(varname, value.get(locals, globals, stackTrace));
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
  }
}
