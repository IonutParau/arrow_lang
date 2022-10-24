part of arrow_tokens;

class ArrowWhileToken extends ArrowToken {
  ArrowToken condition;
  ArrowToken body;

  ArrowWhileToken(this.condition, this.body, super.vm, super.file, super.line);

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
  String get name => "while(${condition.name}) <${body.name}>";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    while (condition.get(locals, globals, stackTrace).truthy) {
      body.run(locals, globals, stackTrace);
    }
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
  }

  @override
  ArrowToken get optimized => ArrowWhileToken(condition.optimized, body.optimized, vm, file, line);
}
