part of arrow_types;

class ArrowMap extends ArrowResource {
  Map<String, ArrowResource> map;

  ArrowMap(this.map);

  @override
  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on map", file, line));
    return this;
  }

  @override
  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to call an map", file, line));
    return this;
  }

  @override
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on map", file, line));
    return this;
  }

  @override
  bool equals(ArrowResource other) {
    if (other is ArrowMap) {
      if (map.length != other.map.length) return false;

      var eq = true;
      map.forEach((key, value) {
        if (other.map[key] == null) {
          eq = false;
        } else if (!value.equals(other.map[key] ?? ArrowNull())) {
          eq = false;
        }
      });

      return eq;
    }

    return false;
  }

  @override
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line) {
    return map[field] ?? ArrowNull();
  }

  @override
  bool greater(ArrowResource other) {
    if (other is ArrowMap) {
      return map.length > other.map.length;
    }

    return false;
  }

  @override
  bool greaterEqual(ArrowResource other) {
    return greater(other) || less(other);
  }

  @override
  bool less(ArrowResource other) {
    if (other is ArrowMap) {
      return map.length < other.map.length;
    }

    return false;
  }

  @override
  bool lessEqual(ArrowResource other) {
    return equals(other) || less(other);
  }

  @override
  ArrowResource mod(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on map", file, line));
    return this;
  }

  @override
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on map", file, line));
    return this;
  }

  @override
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on map", file, line));
    return this;
  }

  @override
  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line) {
    if (resource.type == "null") {
      map.remove(field);
    } else {
      map[field] = resource;
    }
  }

  @override
  String get string {
    var l = [];

    map.forEach((key, value) {
      l.add("$key = ${value.string}");
    });

    return "{${l.join(", ")}}";
  }

  @override
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line) {
    stackTrace.crash(ArrowStackTraceElement("Attempt to perform arithmetic on map", file, line));
    return this;
  }

  @override
  bool get truthy => map.isNotEmpty;

  @override
  String get type => map["__type"] == null ? "map" : map["__type"]!.string;

  @override
  bool approximatelyEquals(ArrowResource other) {
    if (other is ArrowMap) {
      bool failed = false;
      other.map.forEach(
        (key, value) {
          if (!map.containsKey(key)) {
            failed = true;
            return;
          }

          if (!map[key]!.approximatelyEquals(value)) {
            failed = true;
            return;
          }
        },
      );
      return !failed;
    }

    return false;
  }

  @override
  bool matchesShape(ArrowResource shape) {
    if (shape is ArrowMap) {
      bool failed = false;
      shape.map.forEach((key, value) {
        final mv = map[key] ?? ArrowNull();

        if (!mv.matchesShape(shape.map[key] ?? ArrowNull())) failed = true;
      });

      return !failed;
    }

    if (shape is ArrowString) {
      return shape.str == type || shape.str == "any";
    }

    return false;
  }
}
