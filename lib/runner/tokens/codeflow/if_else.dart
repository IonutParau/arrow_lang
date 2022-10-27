part of arrow_tokens;

class ArrowIfElseToken extends ArrowToken {
  ArrowToken condition;
  ArrowToken body;
  ArrowToken fallback;

  ArrowIfElseToken(this.condition, this.body, this.fallback, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return {...condition.dependencies(toIgnore), ...body.dependencies(toIgnore), ...fallback.dependencies(toIgnore)}.toList();
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return ArrowNull();
  }

  @override
  String get name => "if(${condition.name}) -> ${body.name} | ${fallback.name}";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    if (condition.get(locals, globals, stackTrace).truthy) {
      body.run(locals, globals, stackTrace);
    } else {
      fallback.run(locals, globals, stackTrace);
    }
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
  }

  @override
  ArrowToken get optimized => ArrowIfElseToken(condition.optimized, body.optimized, fallback.optimized, vm, file, line);
}
