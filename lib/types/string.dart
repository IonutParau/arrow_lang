part of arrow_types;

class ArrowString extends ArrowResource {
  String str;
  List<String> chars;

  ArrowString(this.str) : chars = str.split('');

  @override
  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    return ArrowString(str + other.string);
  }

  @override
  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to call string", file, line));
    return this;
  }

  @override
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      final n = ArrowNumber(str.length.toDouble()).divide(other, stackTrace, file, line) as ArrowNumber;
      if (n.number.isInfinite) return this;
      if (n.number.isNaN) return ArrowString("");
      if (n.number.isNegative) return ArrowString("");
      return ArrowString(str.substring(0, n.number.toInt()));
    }

    stackTrace.crash(ArrowStackTraceElement("Attempt to divide string by ${other.type}", file, line));
    return this;
  }

  @override
  bool equals(ArrowResource other) {
    if (other is ArrowString) {
      return str == other.str;
    }
    return false;
  }

  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    if (field == "length") {
      return ArrowNumber(str.length.toDouble());
    }
    if (field == "split") {
      return ArrowExternalFunction((params, stackTrace) {
        if (params.isEmpty) return ArrowList([this]);
        return ArrowList(str.split(params[0].string).map<ArrowResource>((e) => ArrowString(e)).toList());
      });
    }
    if (field == "chars") {
      return ArrowList(chars.map<ArrowResource>((e) => ArrowString(e)).toList());
    }
    if (int.tryParse(field) != null) {
      final i = int.parse(field);

      if (i < 0) return ArrowNull();
      if (i >= chars.length) return ArrowNull();

      return ArrowString(chars[i]);
    }
    if (field == "reversed") {
      return ArrowString(chars.reversed.join(""));
    }
    if (field == "empty") {
      return ArrowBool(str.isEmpty);
    }
    if (field == "contains") {
      return ArrowExternalFunction(((params, stackTrace) {
        if (params.isNotEmpty) {
          return ArrowBool(str.contains(params[0].string));
        }

        return ArrowBool(false);
      }));
    }
    if (field == "indexOf") {
      return ArrowExternalFunction(((params, stackTrace) {
        if (params.isNotEmpty) {
          return ArrowNumber(str.indexOf(params[0].string));
        }

        return ArrowNumber(-1);
      }));
    }
    if (field == "lastIndexOf") {
      return ArrowExternalFunction(((params, stackTrace) {
        if (params.isNotEmpty) {
          return ArrowNumber(str.lastIndexOf(params[0].string));
        }

        return ArrowNumber(-1);
      }));
    }
    if (field == "replaceAll") {
      return ArrowExternalFunction(((params, stackTrace) {
        while (params.length < 2) {
          params = [...params, ArrowNull()];
        }

        return ArrowString(str.replaceAll(params[0].string, params[1].string));
      }));
    }
    if (field == "replaceFirst") {
      return ArrowExternalFunction(((params, stackTrace) {
        while (params.length < 2) {
          params = [...params, ArrowNull()];
        }

        return ArrowString(str.replaceFirst(params[0].string, params[1].string));
      }));
    }
    if (field == "lower") {
      return ArrowString(str.toLowerCase());
    }
    if (field == "upper") {
      return ArrowString(str.toUpperCase());
    }
    return ArrowNull();
  }

  @override
  bool greater(ArrowResource other) {
    if (other is ArrowString) {
      return str.length > other.str.length;
    }

    return false;
  }

  @override
  bool greaterEqual(ArrowResource other) {
    return greater(other) || equals(other);
  }

  @override
  bool less(ArrowResource other) {
    if (other is ArrowString) {
      return str.length < other.str.length;
    }

    return false;
  }

  @override
  bool lessEqual(ArrowResource other) {
    return less(other) || equals(other);
  }

  @override
  ArrowResource mod(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to mod string by ${other.type}", file, line));
    return this;
  }

  @override
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      return ArrowString(List<String>.generate(other.number.toInt(), (i) => str).join(""));
    }

    stackTrace.crash(ArrowStackTraceElement("Attempt to multiply string by ${other.type}", file, line));
    return this;
  }

  @override
  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to modify a field from string", file, line));
  }

  @override
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    return ArrowString(str.replaceFirst(other.string, ""));
  }

  @override
  bool get truthy => str.isNotEmpty;

  @override
  String get type => "string";

  @override
  String get string => str;

  @override
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to raise string to power of ${other.type}", file, line));
    return this;
  }

  @override
  bool approximatelyEquals(ArrowResource other) {
    return other is ArrowString;
  }

  @override
  bool matchesShape(ArrowResource shape) {
    if (shape is ArrowString) return shape.str == "string" || shape.str == "any";
    return false;
  }
}
