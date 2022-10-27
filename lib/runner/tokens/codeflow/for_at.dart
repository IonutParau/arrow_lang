part of arrow_tokens;

class ArrowForAtToken extends ArrowToken {
  String varname;
  String atname;
  ArrowToken toIter;
  ArrowToken body;

  ArrowForAtToken(this.varname, this.atname, this.toIter, this.body, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    final l = <String>[];

    l.addAll(toIter.dependencies(toIgnore));
    l.addAll(body.dependencies([...toIgnore, varname, atname]));

    return l;
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return ArrowNull();
  }

  @override
  String get name => "for($varname at $atname in ${toIter.name}) <${body.name}>";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final size = locals.size;

    final l = toIter.get(locals, globals, stackTrace);

    if (l is ArrowList) {
      var i = 0;
      for (var element in l.elements) {
        locals.define(atname, ArrowNumber(i));
        locals.define(varname, element);
        stackTrace.push(ArrowStackTraceElement("For Loop Body", file, line));
        body.run(locals, globals, stackTrace);
        if (locals.has("")) break;
        stackTrace.pop();
        locals.removeAmount(2);
        i++;
      }
    } else if (l is ArrowMap) {
      l.map.forEach((key, value) {
        locals.define(atname, ArrowString(key));
        locals.define(varname, value);
        stackTrace.push(ArrowStackTraceElement("For Loop Body", file, line));
        body.run(locals, globals, stackTrace);
        if (locals.has("")) return;
        stackTrace.pop();
        locals.removeAmount(2);
      });
    } else {
      stackTrace.crash(ArrowStackTraceElement("Attempt to iterate value with no iterator", file, line));
    }

    final returned = locals.getByName("");
    locals.removeAmount(locals.size - size);
    if (returned != null) locals.define("", returned);

    locals.removeAmount(locals.size - size);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
  }

  @override
  ArrowToken get optimized => ArrowForAtToken(varname, atname, toIter.optimized, body.optimized, vm, file, line);
}
