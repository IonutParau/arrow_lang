part of arrow_tokens;

class ArrowListToken extends ArrowToken {
  List<ArrowToken> list;

  ArrowListToken(this.list, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    final l = <String>[];

    for (var value in list) {
      l.addAll(value.dependencies(toIgnore));
    }

    return l;
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return ArrowList(list.map((value) => value.get(locals, globals, stackTrace)).toList());
  }

  @override
  String get name => "list";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    return;
  }

  @override
  ArrowToken get optimized => ArrowListToken(list.map((e) => e.optimized).toList(), vm, file, line);
}
