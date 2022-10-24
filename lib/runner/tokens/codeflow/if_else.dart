part of arrow_tokens;

class ArrowIfElseToken extends ArrowToken {
  ArrowToken condition;
  ArrowToken body;
  ArrowToken fallback;

  ArrowIfElseToken(this.condition, this.body, this.fallback, super.vm, super.file, super.line);

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
}
