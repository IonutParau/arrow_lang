part of arrow_tokens;

class ArrowMapToken extends ArrowToken {
  Map<ArrowToken, ArrowToken> map;

  ArrowMapToken(this.map, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    final l = <String>[];

    map.forEach((key, value) {
      l.addAll(key.dependencies(toIgnore));
      l.addAll(value.dependencies(toIgnore));
    });

    return l;
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final m = <String, ArrowResource>{};

    map.forEach((key, value) {
      m[key.get(locals, globals, stackTrace).string] = value.get(locals, globals, stackTrace);
    });

    return ArrowMap(m);
  }

  @override
  String get name => "map";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }
}
