part of arrow_types;

class ArrowNumber extends ArrowResource {
  double number;

  ArrowNumber(num n) : number = n.toDouble();

  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    if (field == "positive") {
      return ArrowBool(!number.isNegative);
    }
    if (field == "negative") {
      return ArrowBool(number.isNegative);
    }
    if (field == "infinite") {
      return ArrowBool(number.isInfinite);
    }
    if (field == "finite") {
      return ArrowBool(number.isFinite);
    }
    if (field == "valid") {
      return ArrowBool(!number.isNaN);
    }
    if (field == "invalid") {
      return ArrowBool(number.isNaN);
    }
    if (field == "sign") {
      return ArrowNumber(number.sign);
    }
    if (field == "clamp") {
      return ArrowExternalFunction((params, stackTrace) {
        while (params.length < 2) {
          params = [...params, ArrowNull()];
        }
        if (params[0] is ArrowNumber && params[1] is ArrowNumber) {
          final n1 = params[0] as ArrowNumber;
          final n2 = params[1] as ArrowNumber;

          return ArrowNumber(number.clamp(n1.number, n2.number));
        }

        return ArrowNull();
      });
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
      if (number == 0 && other.number == 0) {
        return ArrowNumber(double.nan);
      }
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
      if (number == 0 && other.number == 0) return ArrowNumber(double.nan);
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
