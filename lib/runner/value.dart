part of arrow_runner;

abstract class ArrowResource {
  ArrowResource getField(String field, ArrowStackTrace stackTrace, String file, int line);

  void setField(String field, ArrowResource resource, ArrowStackTrace stackTrace, String file, int line);

  ArrowResource call(List<ArrowResource> params, ArrowStackTrace stackTrace, String file, int line);

  ArrowResource add(ArrowResource other, ArrowStackTrace stackTrace, String file, int line);
  ArrowResource subtract(ArrowResource other, ArrowStackTrace stackTrace, String file, int line);
  ArrowResource multiply(ArrowResource other, ArrowStackTrace stackTrace, String file, int line);
  ArrowResource divide(ArrowResource other, ArrowStackTrace stackTrace, String file, int line);
  ArrowResource mod(ArrowResource other, ArrowStackTrace stackTrace, String file, int line);
  ArrowResource power(ArrowResource other, ArrowStackTrace stackTrace, String file, int line);
  bool equals(ArrowResource other);
  bool greater(ArrowResource other);
  bool less(ArrowResource other);
  bool greaterEqual(ArrowResource other);
  bool lessEqual(ArrowResource other);

  bool get truthy;

  String get type;

  String get string;
}

class ArrowGlobals {
  final Map<String, ArrowResource> _globals = {};

  ArrowResource get(String name) {
    return _globals[name] ?? ArrowNull();
  }

  void set(String name, ArrowResource resource) {
    _globals[name] = resource;
  }
}

class ArrowVariable {
  String name;
  ArrowResource value;

  ArrowVariable(this.name, this.value);
}

/// A stack of ArrowVariables used to deal with local variables.
class ArrowLocals {
  /// The raw stack. Don't manually manage this, use the helper functions.
  List<ArrowVariable> stack = [];

  /// Get the size of the stack
  int get size => stack.length;

  /// Unnamed constructor
  ArrowLocals();

  /// Constructor for specifying your own stack
  ArrowLocals.withStack(this.stack);

  /// Define a variable on the stack
  void define(String name, ArrowResource value) {
    stack.add(ArrowVariable(name, value));
  }

  /// Remove the variable by name. Removes only the first one of that name that it meets. Also if it was successful
  bool removeByName(String name) {
    var i = stack.length - 1;

    while (i >= 0) {
      if (stack[i].name == name) {
        stack.removeAt(i);
        return true;
      }
    }

    return false;
  }

  /// Gets the variable, by name. Returns null if no variable if that name is found.
  bool has(String name) {
    var i = stack.length - 1;

    while (i >= 0) {
      if (stack[i].name == name) {
        return true;
      }
      i--;
    }

    return false;
  }

  /// Gets the variable, by name. Returns null if no variable if that name is found.
  ArrowResource? getByName(String name) {
    var i = stack.length - 1;

    while (i >= 0) {
      if (stack[i].name == name) {
        return stack[i].value;
      }
      i--;
    }

    return null;
  }

  /// Sets the variable, by name, to a new value, and returns if it actually modified anything
  bool setByName(String name, ArrowResource value) {
    var i = stack.length - 1;

    while (i >= 0) {
      if (stack[i].name == name) {
        stack[i].value = value;
        return true;
      }
      i--;
    }

    return false;
  }

  /// Removes the first [amount] elements. Also returns how many it deleted.
  int removeAmount(int amount) {
    var count = 0;
    for (var i = 0; i < amount; i++) {
      if (stack.isNotEmpty) {
        count++;
        stack.removeLast();
      }
    }
    return count;
  }

  /// Gives us a copy of the stack, but, each variable in here is linked to the old one.
  ArrowLocals copy() {
    return ArrowLocals.withStack([...stack]);
  }

  /// Gives us a copy of the stack, but, each variable in here is linked to the old one.
  ArrowLocals copyByNames(Set<String> names) {
    if (names.isEmpty) return ArrowLocals();

    final newStack = <ArrowVariable>[];
    final toCopy = {...names};

    var i = stack.length - 1;

    while (i >= 0) {
      if (toCopy.contains(stack[i].name)) {
        newStack.add(stack[i]);
        toCopy.remove(stack[i].name);
        if (toCopy.isEmpty) break;
      }
      i--;
    }

    return ArrowLocals.withStack(newStack);
  }
}
