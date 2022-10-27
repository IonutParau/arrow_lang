part of arrow_tokens;

class ArrowBlockToken extends ArrowToken {
  List<ArrowToken> contents;

  ArrowBlockToken(this.contents, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    final l = <String>{};
    final ignore = [...toIgnore];

    for (var content in contents) {
      if (content is ArrowLetToken) {
        ignore.add(content.varname);
      }
      if (content is ArrowDefineFunctionToken) {
        if (content.varname is ArrowVariableToken) {
          ignore.add((content.varname as ArrowVariableToken).varname);
        }
      }
      if (content is ArrowConstValToken) {
        continue; // Nobody needs a constant value at root lol
      }
      l.addAll(content.dependencies(ignore));
    }

    return l.toList();
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    run(locals, globals, stackTrace);
    final value = locals.getByName("");
    locals.removeByName("");
    return value ?? ArrowNull();
  }

  @override
  String get name => "arrow:code_block";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final size = locals.size;

    for (var content in contents) {
      content.run(locals, globals, stackTrace);
      if (locals.has("")) {
        if (content is ArrowCallToken) {
          locals.removeByName("");
        } else {
          break;
        }
      }
    }
    final value = locals.getByName("");
    locals.removeAmount(locals.size - size);
    if (value != null) locals.define("", value);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    run(locals, globals, stackTrace);
    locals.removeByName("");
  }

  @override
  ArrowToken get optimized {
    final newContents = <ArrowToken>[];

    for (var i = 0; i < contents.length; i++) {
      final token = contents[i];

      // If it's reading a varaible at the top level, say goodbye
      if (token is ArrowVariableToken) continue;
      if (token is ArrowLetToken) {
        final name = token.varname;
        var useful = false;

        for (var j = i + 1; j < contents.length; j++) {
          final otherToken = contents[j];

          if (otherToken.dependencies([]).contains(name)) {
            useful = true;
            break;
          }
        }

        if (!useful) continue;
      }
      if (token is ArrowDefineFunctionToken) {
        final vname = token.varname;
        if (vname is ArrowVariableToken) {
          final name = vname.varname;
          var useful = false;

          for (var j = i + 1; j < contents.length; j++) {
            final otherToken = contents[j];

            if (otherToken.dependencies([]).contains(name)) {
              useful = true;
              break;
            }
          }

          if (!useful) continue;
        }
      }
      if (token is ArrowClassToken) {
        final vname = token.classname;
        if (vname is ArrowVariableToken) {
          final name = vname.varname;
          var useful = false;

          for (var j = i + 1; j < contents.length; j++) {
            final otherToken = contents[j];

            if (otherToken.dependencies([]).contains(name)) {
              useful = true;
              break;
            }
          }

          if (!useful) continue;
        }
      }
      newContents.add(token.optimized);
    }

    return ArrowBlockToken(newContents, vm, file, line);
  }
}
