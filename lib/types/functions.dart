part of arrow_types;

class ArrowFunction extends ArrowResource {
  ArrowToken body;
  List<String> params;
  ArrowLocals locals;

  ArrowFunction(this.params, this.locals, this.body);

  @override
  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line) {
    final size = locals.size;

    for (var i = 0; i < this.params.length; i++) {
      if (params.length <= i) {
        locals.define(this.params[i], ArrowNull());
      } else {
        locals.define(this.params[i], params[i]);
      }
    }

    body.run(
      locals,
      body.vm.globals,
      stackTrace,
    );

    final returned = locals.getByName("");

    locals.removeAmount(locals.size - size);

    return returned ?? ArrowNull();
  }

  @override
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  bool equals(ArrowResource other) {
    return false;
  }

  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to read field of function", file, line));
    return this;
  }

  @override
  bool greater(ArrowResource other) {
    return false;
  }

  @override
  bool greaterEqual(ArrowResource other) {
    return false;
  }

  @override
  bool less(ArrowResource other) {
    return false;
  }

  @override
  bool lessEqual(ArrowResource other) {
    return false;
  }

  @override
  ArrowResource mod(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to modify field of function", file, line));
  }

  @override
  String get string => "ArrowFunction:$hashCode";

  @override
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  bool get truthy => true;

  @override
  String get type => "function";

  @override
  bool approximatelyEquals(ArrowResource other) {
    return other is ArrowFunction || other is ArrowExternalFunction;
  }

  @override
  bool matchesShape(ArrowResource shape) {
    if (shape is ArrowString) {
      return shape.str == "function";
    }
    return false;
  }
}

class ArrowExternalFunction extends ArrowResource {
  ArrowResource Function(List<ArrowResource> params, ArrowStackTrace stackTrace) func;
  int minArgs;

  ArrowExternalFunction(this.func, [this.minArgs = 0]);

  @override
  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line) {
    while (params.length < minArgs) {
      params = [...params, ArrowNull()];
    }
    return func(params, stackTrace);
  }

  @override
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  bool equals(ArrowResource other) {
    return false;
  }

  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to read field of function", file, line));
    return this;
  }

  @override
  bool greater(ArrowResource other) {
    return false;
  }

  @override
  bool greaterEqual(ArrowResource other) {
    return false;
  }

  @override
  bool less(ArrowResource other) {
    return false;
  }

  @override
  bool lessEqual(ArrowResource other) {
    return false;
  }

  @override
  ArrowResource mod(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to modify field of function", file, line));
  }

  @override
  String get string => "ArrowFunction:$hashCode";

  @override
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on function", file, line));
    return this;
  }

  @override
  bool get truthy => true;

  @override
  String get type => "function";

  @override
  bool approximatelyEquals(ArrowResource other) {
    return other is ArrowFunction || other is ArrowExternalFunction;
  }

  @override
  bool matchesShape(ArrowResource shape) {
    if (shape is ArrowString) {
      return shape.str == "function" || shape.str == "any";
    }
    return false;
  }
}
