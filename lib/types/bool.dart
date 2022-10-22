part of arrow_types;

class ArrowBool extends ArrowResource {
  bool boolean;

  ArrowBool(this.boolean);

  @override
  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    return this;
  }

  @override
  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to call a bool.", file, line));
    return this;
  }

  @override
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on a bool.", file, line));
    return this;
  }

  @override
  bool equals(ArrowResource other) {
    if (other is ArrowBool) {
      return boolean == other.boolean;
    }

    return false;
  }

  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to read a field from a bool.", file, line));
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
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on a bool.", file, line));
    return this;
  }

  @override
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on a bool.", file, line));
    return this;
  }

  @override
  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to set the field of a bool.", file, line));
  }

  @override
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on a bool.", file, line));
    return this;
  }

  @override
  bool get truthy => boolean;

  @override
  String get type => "bool";

  @override
  String get string => boolean ? "true" : "false";

  @override
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on a bool.", file, line));
    return this;
  }
}
