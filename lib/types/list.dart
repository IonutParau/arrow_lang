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
    if (field == "insert") {
      return ArrowExternalFunction((params, stackTrace) {
        while (params.length < 2) {
          params = [...params, ArrowNull()];
        }

        if (params[0] is ArrowNumber) {
          elements.insert((params[0] as ArrowNumber).number.toInt(), params[1]);
        }

        return ArrowNull();
      });
    }
    if (field == "contains") {
      return ArrowExternalFunction((params, stackTrace) {
        while (params.isNotEmpty) {
          params = [...params, ArrowNull()];
        }

        for (var element in elements) {
          if (element.equals(params[0])) return ArrowBool(true);
        }

        return ArrowBool(false);
      });
    }
    if (field == "clear") {
      return ArrowExternalFunction((params, stackTrace) {
        elements.clear();

        return ArrowNull();
      });
    }
    if (field == "shuffle") {
      return ArrowExternalFunction((params, stackTrace) {
        elements.shuffle(rng);

        return ArrowNull();
      });
    }
    if (field == "forEach") {
      return ArrowExternalFunction((params, stackTrace) {
        for (var element in elements) {
          stackTrace.push(ArrowStackTraceElement("forEach:arg1", file, line));
          params[0].call([element], stackTrace, "arrow:internal", 0);
          stackTrace.pop();
        }

        return ArrowNull();
      }, 1);
    }
    if (field == "convert") {
      return ArrowExternalFunction((params, stackTrace) {
        final elements = <ArrowResource>[];

        for (var element in this.elements) {
          stackTrace.push(ArrowStackTraceElement("convert:arg1", file, line));
          elements.add(params[0].call([element], stackTrace, "arrow:internal", 0));
          stackTrace.pop();
        }

        return ArrowList(elements);
      }, 1);
    }
    if (field == "map") {
      return ArrowMap(elements.asMap().map((key, value) {
        return MapEntry(key.toString(), value);
      }));
    }
    if (field == "join") {
      return ArrowExternalFunction((params, stackTrace) {
        return ArrowString(elements.join(params[0].string));
      }, 1);
    }
    if (field == "copy") {
      return ArrowList([...elements]);
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
