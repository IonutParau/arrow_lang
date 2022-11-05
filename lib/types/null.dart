part of arrow_types;

class ArrowNull extends ArrowResource {
  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to read a field from null", file, line));
    return ArrowNull();
  }

  @override
  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to call null", file, line));
    return ArrowNull();
  }

  @override
  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to modify field in null", file, line));
  }

  @override
  String get type => "null";

  @override
  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on null", file, line));
    return this;
  }

  @override
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on null", file, line));
    return this;
  }

  @override
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on null", file, line));
    return this;
  }

  @override
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on null", file, line));
    return this;
  }

  @override
  ArrowResource mod(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on null", file, line));
    return this;
  }

  @override
  bool equals(ArrowResource other) {
    return other is ArrowNull;
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
    return other is ArrowNull;
  }

  @override
  bool lessEqual(ArrowResource other) {
    return other is ArrowNull;
  }

  @override
  bool get truthy => false;

  @override
  String get string => "null";

  @override
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on null", file, line));
    return this;
  }

  @override
  bool approximatelyEquals(ArrowResource other) {
    return other is ArrowNull;
  }

  @override
  bool matchesShape(ArrowResource shape) {
    if (shape is ArrowString) return shape.str == "null";
    return false;
  }
}
