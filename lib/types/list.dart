part of arrow_types;

class ArrowList extends ArrowResource {
  List<ArrowResource> elements;

  ArrowList(this.elements);

  @override
  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    return ArrowList([...elements, other]);
  }

  @override
  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to call list", file, line));
    return this;
  }

  @override
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to divide list by ${other.type}", file, line));
    return this;
  }

  @override
  bool equals(ArrowResource other) {
    return this == other;
  }

  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    if (field == "length") {
      return ArrowNumber(elements.length.toDouble());
    }
    if (int.tryParse(field) != null) {
      final i = int.parse(field);

      if (i < 0 || i >= elements.length) {
        return ArrowNull();
      }

      return elements[i];
    }
    if (field == "join") {
      return ArrowExternalFunction((params, stackTrace) {
        if (params.isEmpty) return ArrowString(elements.map((e) => e.string).join(""));
        final sep = params[0];
        if (sep is ArrowString) {
          return ArrowString(elements.map((e) => e.string).join(sep.str));
        }
        return ArrowString(elements.map((e) => e.string).join(""));
      });
    }
    if (field == "push") {
      return ArrowExternalFunction((params, stackTrace) {
        elements.addAll(params);
        return ArrowNull();
      });
    }
    if (field == "pop") {
      return ArrowExternalFunction((params, stackTrace) {
        return elements.removeLast();
      });
    }
    if (field == "remove") {
      return ArrowExternalFunction((params, stackTrace) {
        if (params.isNotEmpty) {
          final other = params[0];
          if (other is ArrowNumber) {
            final i = other.number.toInt();

            if (i >= 0 && i < elements.length) {
              return elements[i];
            }
          }
        }

        return ArrowNull();
      });
    }

    return ArrowNull();
  }

  @override
  bool greater(ArrowResource other) {
    if (other is ArrowList) {
      return elements.length > other.elements.length;
    }

    return false;
  }

  @override
  bool greaterEqual(ArrowResource other) {
    return equals(other) || greater(other);
  }

  @override
  bool less(ArrowResource other) {
    if (other is ArrowList) {
      return elements.length < other.elements.length;
    }

    return false;
  }

  @override
  bool lessEqual(ArrowResource other) {
    return equals(other) || less(other);
  }

  @override
  ArrowResource mod(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to mod list by ${other.type}", file, line));
    return this;
  }

  @override
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to multiply list by ${other.type}", file, line));
    return this;
  }

  @override
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to raise list to power of ${other.type}", file, line));
    return this;
  }

  @override
  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line) {
    if (int.tryParse(field) != null) {
      final i = int.parse(field);
      if (i >= 0 || i < elements.length) {
        elements[i] = resource;
      }
    }
  }

  @override
  String get string => "[${elements.map<String>((e) => e.string).join(", ")}]";

  @override
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    if (other is ArrowNumber) {
      final l = [...elements];
      if (other.number < 0 || other.number >= elements.length) {
        return this;
      }
      l.removeAt(other.number.toInt());
      return ArrowList(l);
    }
    stackTrace.crash(ArrowStackTraceElement("Attempt to subtract ${other.type} out of list", file, line));
    return this;
  }

  @override
  bool get truthy => elements.isNotEmpty;

  @override
  String get type => "list";
}
