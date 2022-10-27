part of arrow_tokens;

class ArrowClassToken extends ArrowToken {
  ArrowToken classname;
  List<String> params;
  ArrowToken body;

  ArrowClassToken(this.classname, this.params, this.body, ArrowVM vm, String file, int line) : super(vm, file, line);

  void handleInherit(ArrowResource superClass, ArrowStackTrace stackTrace, ArrowMap instance) {
    if (superClass is ArrowMap) {
      superClass.map.forEach((key, value) {
        if (key != "__type") {
          instance.map[key] = value;
        }
      });
    }
    if (superClass is ArrowList) {
      for (var superClassElement in superClass.elements) {
        stackTrace.push(ArrowStackTraceElement("inherit()", "arrow:internal", 0));
        handleInherit(superClassElement, stackTrace, instance);
        stackTrace.pop();
      }
    }
    if (superClass is ArrowFunction) {
      stackTrace.push(ArrowStackTraceElement("inherit()", "arrow:internal", 0));
      handleInherit(superClass.call([], stackTrace, file, line), stackTrace, instance);
      stackTrace.pop();
    }
  }

  ArrowToken classBody(ArrowLocals locals) {
    // Class body is just normal body but with some boilerplate wrapped around it (invisible code)
    return ArrowBlockToken(
      [
        ArrowLetToken(
          "this",
          ArrowMapToken(
            {ArrowStringToken("__type", vm, file, line): ArrowStringToken(classname.name, vm, file, line)},
            vm,
            file,
            line,
          ),
          vm,
          file,
          line,
        ),
        ArrowLetToken(
          "inherit",
          ArrowConstValToken(
            ArrowExternalFunction((params, stackTrace) {
              final superClass = params.first;

              final instance = locals.getByName("this");

              if (instance != null) {
                if (instance is ArrowMap) {
                  handleInherit(superClass, stackTrace, instance);
                }
              }

              return ArrowNull();
            }, 1),
            vm,
            file,
            line,
          ),
          vm,
          file,
          line,
        ),
        body,
        ArrowReturnToken(
          ArrowVariableToken(
            "this",
            vm,
            file,
            line,
          ),
          vm,
          file,
          line,
        ),
      ],
      vm,
      file,
      line,
    ).optimized;
  }

  @override
  List<String> dependencies(List<String> toIgnore) {
    return body.dependencies([...toIgnore, ...params, "this", "inherit"]);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    return ArrowNull();
  }

  @override
  String get name => classname.name;

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final requiredVars = dependencies([]);
    final newLocals = locals.copyByNames(requiredVars.toSet());
    final f = ArrowFunction(params, newLocals, classBody(newLocals));
    if (classname is ArrowFieldToken) {
      classname.set(locals, globals, stackTrace, f);
    } else if (classname is ArrowVariableToken) {
      locals.define((classname as ArrowVariableToken).varname, f);
    }
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }

  @override
  ArrowToken get optimized => ArrowClassToken(classname, params, body.optimized, vm, file, line);
}
