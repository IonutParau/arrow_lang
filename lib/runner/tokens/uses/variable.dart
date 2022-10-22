part of arrow_tokens;

class ArrowVariableToken extends ArrowToken {
  String varname;

  ArrowVariableToken(this.varname, super.vm, super.file, super.line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    if (toIgnore.contains(varname)) return [];

    return [varname];
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final val = locals.getByName(varname);

    if (val == null) {
      return globals.get(varname);
    }

    return val;
  }

  @override
  String get name => varname;

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    if (locals.setByName(varname, other)) {
      globals.set(varname, other);
    }
  }
}
