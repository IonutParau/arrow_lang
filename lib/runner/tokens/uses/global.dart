part of arrow_tokens;

class ArrowGlobalToken extends ArrowToken {
  String globalName;
  ArrowToken value;

  ArrowGlobalToken(this.globalName, this.value, super.vm, super.file, super.line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return value.dependencies(toIgnore);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return globals.get(globalName);
  }

  @override
  String get name => globalName;

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final val = value.get(locals, globals, stackTrace);
    globals.set(globalName, val);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }
}
