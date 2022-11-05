part of arrow_tokens;

class ArrowShapeToken extends ArrowToken {
  ArrowToken shapename;
  ArrowToken body;

  ArrowShapeToken(this.shapename, this.body, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return [...shapename.dependencies(toIgnore), ...body.dependencies(toIgnore)];
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return ArrowNull();
  }

  @override
  String get name => "shape(${shapename.name}) -> ${body.name}";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    stackTrace.push(ArrowStackTraceElement("Define ${shapename.name}", file, line));
    final val = body.get(locals, globals, stackTrace);
    if (shapename is ArrowFieldToken) {
      shapename.set(locals, globals, stackTrace, val);
    } else if (shapename is ArrowVariableToken) {
      locals.define((shapename as ArrowVariableToken).varname, val);
    }
    stackTrace.pop();
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
  }

  @override
  ArrowToken get optimized => ArrowShapeToken(shapename.optimized, body.optimized, vm, file, line);
}

class ArrowShapeBody extends ArrowToken {
  Map<String, ArrowToken> shapeContents;

  ArrowShapeBody(this.shapeContents, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return shapeContents.values.toList().fold<List<String>>([], (previousValue, element) => [...previousValue, ...element.dependencies(toIgnore)]);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    stackTrace.push(ArrowStackTraceElement("Constructing Shape", file, line));

    final m = <String, ArrowResource>{};

    shapeContents.forEach(
      (key, value) {
        stackTrace.push(ArrowStackTraceElement("Constructing Shape Field Type", file, line));
        m[key] = value.get(locals, globals, stackTrace);
        stackTrace.pop();
      },
    );

    stackTrace.pop();

    return ArrowMap(m);
  }

  @override
  String get name => "shapeBody:$hashCode";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    get(locals, globals, stackTrace);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    get(locals, globals, stackTrace);
  }
}
