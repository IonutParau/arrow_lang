part of arrow_tokens;

class ArrowBlockToken extends ArrowToken {
  List<ArrowToken> contents;

  ArrowBlockToken(this.contents, super.vm, super.file, super.line);

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
      if (locals.has("")) break;
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
}
