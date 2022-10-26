part of arrow_tokens;

class ArrowClassToken extends ArrowToken {
  ArrowToken classname;
  List<String> params;
  ArrowToken body;

  ArrowClassToken(this.classname, this.params, this.body, ArrowVM vm, String file, int line) : super(vm, file, line);

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

              if (superClass is ArrowMap) {
                final instance = locals.getByName("this");
                if (instance != null) {
                  if (instance is ArrowMap) {
                    superClass.map.forEach((key, value) {
                      if (key != "__type") instance.map[key] = value;
                    });
                  }
                }
              }

              if (superClass is ArrowFunction) {
                final superClassReturn = superClass.call([], stackTrace, file, line);

                if (superClassReturn is ArrowMap) {
                  final instance = locals.getByName("this");
                  if (instance != null) {
                    if (instance is ArrowMap) {
                      superClassReturn.map.forEach((key, value) {
                        if (key != "__type") instance.map[key] = value;
                      });
                    }
                  }
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
    );
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
