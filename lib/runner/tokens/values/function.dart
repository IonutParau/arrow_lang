part of arrow_tokens;

class ArrowDefineFunctionToken extends ArrowToken {
  ArrowToken varname;
  List<String> params;
  ArrowToken body;

  ArrowDefineFunctionToken(this.varname, this.params, this.body, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return body.dependencies([...toIgnore, ...params]);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return ArrowNull();
  }

  @override
  String get name => varname.name;

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final requiredVars = dependencies([]);
    final newLocals = locals.copyByNames(requiredVars.toSet());
    final f = ArrowFunction(params, newLocals, body);
    if (varname is ArrowFieldToken) {
      varname.set(locals, globals, stackTrace, f);
    } else if (varname is ArrowVariableToken) {
      locals.define((varname as ArrowVariableToken).varname, f);
    }
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }
}

class ArrowAnonymousFunctionToken extends ArrowToken {
  List<String> params;
  ArrowToken body;

  ArrowAnonymousFunctionToken(this.params, this.body, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return body.dependencies([...toIgnore, ...params]);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final requiredVars = dependencies([]);
    final newLocals = locals.copyByNames(requiredVars.toSet());
    return ArrowFunction(params, newLocals, body);
  }

  @override
  String get name => "arrow:closure";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }
}
