part of arrow_tokens;

class ArrowNotToken extends ArrowToken {
  ArrowToken val;

  ArrowNotToken(this.val, super.vm, super.file, super.line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return val.dependencies(toIgnore);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final v = val.get(locals, globals, stackTrace);
    return ArrowBool(!v.truthy);
  }

  @override
  String get name => "not";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    get(locals, globals, stackTrace);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    get(locals, globals, stackTrace);
  }
}
