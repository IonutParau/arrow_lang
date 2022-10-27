part of arrow_tokens;

class ArrowReturnToken extends ArrowToken {
  ArrowToken val;

  ArrowReturnToken(this.val, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return val.dependencies(toIgnore);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return locals.getByName("") ?? ArrowNull();
  }

  @override
  String get name => "arrow:return";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    locals.define("", val.get(locals, globals, stackTrace));
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
  }

  @override
  ArrowToken get optimized => ArrowReturnToken(val.optimized, vm, file, line);
}
