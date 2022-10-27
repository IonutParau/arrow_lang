part of arrow_tokens;

class ArrowFieldToken extends ArrowToken {
  ArrowToken field;
  ArrowToken host;

  ArrowFieldToken(this.field, this.host, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return {...host.dependencies(toIgnore), ...field.dependencies(toIgnore)}.toList();
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    stackTrace.push(ArrowStackTraceElement("Read field $name", file, line));
    final hostValue = host.get(locals, globals, stackTrace);
    final value = hostValue.getField(field.get(locals, globals, stackTrace).string, stackTrace, file, line);
    stackTrace.pop();
    return value;
  }

  @override
  String get name => "${host.name}.${field.name}";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    return;
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    stackTrace.push(ArrowStackTraceElement("Write field $name", file, line));
    final hostValue = host.get(locals, globals, stackTrace);
    final fieldValue = field.get(locals, globals, stackTrace);
    hostValue.setField(fieldValue.string, other, stackTrace, file, line);
    stackTrace.pop();
  }

  @override
  ArrowToken get optimized => ArrowFieldToken(field.optimized, host.optimized, vm, file, line);
}
