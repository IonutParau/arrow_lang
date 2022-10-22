part of arrow_types;

class ArrowNumber extends ArrowResource {
  double number;

  ArrowNumber(num n) : number = n.toDouble();

  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    if (field == "positive") {
      return ArrowBool(number > 0);
    }
    if (field == "negative") {
      return ArrowBool(number < 0);
    }
    if (field == "infinite") {
      return ArrowBool(number == double.infinity || number == double.negativeInfinity);
    }
    if (field == "valid") {
      return ArrowBool(number != double.nan);
    }
    return ArrowNull();
  }

  @override
  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to call a number.", file, line));
    return ArrowNull();
  }

  @override
  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to modify field in a number.", file, line));
  }

  @override
  String get type => "null";

  @override
  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      return ArrowNumber(number + other.number);
    }
    stackTrace.crash(ArrowStackTraceElement("Attempt to add ${other.type} to a number.", file, line));
    return this;
  }

  @override
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      if (other.number == 0) {
        return ArrowNumber(number.isNegative ? double.negativeInfinity : double.infinity);
      }
      if (other.number == double.nan) {
        return ArrowNumber(double.nan);
      }
      if (number == double.nan) {
        return ArrowNumber(double.nan);
      }
      return ArrowNumber(number / other.number);
    }
    stackTrace.crash(ArrowStackTraceElement("Attempt to divide a number by ${other.type}.", file, line));
    return this;
  }

  @override
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      return ArrowNumber(number * other.number);
    }
    stackTrace.crash(ArrowStackTraceElement("Attempt to a number by ${other.type}.", file, line));
    return this;
  }

  @override
  ArrowResource mod(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      if (other.number == 0) {
        return ArrowNumber(number.isNegative ? double.negativeInfinity : double.infinity);
      }
      if (number == double.nan) {
        return ArrowNumber(double.nan);
      }
      if (other.number == double.nan) {
        return ArrowNumber(double.nan);
      }
      return ArrowNumber(number % other.number);
    }
    stackTrace.crash(ArrowStackTraceElement("Attempt to mod a number by ${other.type}.", file, line));
    return this;
  }

  @override
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      return ArrowNumber(number - other.number);
    }
    stackTrace.crash(ArrowStackTraceElement("Attempt to subtract ${other.type} from a number.", file, line));
    return this;
  }

  @override
  bool equals(ArrowResource other) {
    if (other is ArrowNumber) {
      return number == other.number;
    }

    return false;
  }

  @override
  bool greater(ArrowResource other) {
    if (other is ArrowNumber) {
      return number > other.number;
    }

    return false;
  }

  @override
  bool greaterEqual(ArrowResource other) {
    if (other is ArrowNumber) {
      return number >= other.number;
    }

    return false;
  }

  @override
  bool less(ArrowResource other) {
    if (other is ArrowNumber) {
      return number < other.number;
    }

    return false;
  }

  @override
  bool lessEqual(ArrowResource other) {
    if (other is ArrowNumber) {
      return number <= other.number;
    }

    return false;
  }

  @override
  bool get truthy => number != 0;

  @override
  String get string {
    var s = number.toString();

    if (s.endsWith('.0')) {
      return s.replaceAll('.0', '');
    }

    return s;
  }

  @override
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      return ArrowNumber(pow(number, other.number).toDouble());
    }
    stackTrace.crash(ArrowStackTraceElement("Attempt to raise number to power of ${other.type}.", file, line));
    return this;
  }
}
