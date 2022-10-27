part of arrow_tokens;

class ArrowIfToken extends ArrowToken {
  ArrowToken condition;
  ArrowToken body;

  ArrowIfToken(this.condition, this.body, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return {...condition.dependencies(toIgnore), ...body.dependencies(toIgnore)}.toList();
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return ArrowNull();
  }

  @override
  String get name => "if(${condition.name}) -> ${body.name}";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    if (condition.get(locals, globals, stackTrace).truthy) {
      body.run(locals, globals, stackTrace);
    }
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
  }

  @override
  ArrowToken get optimized => ArrowIfToken(condition.optimized, body.optimized, vm, file, line);
}
