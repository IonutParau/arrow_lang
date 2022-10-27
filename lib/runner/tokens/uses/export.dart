part of arrow_tokens;

class ArrowExportToken extends ArrowToken {
  ArrowToken toExport;
  ArrowToken exportField;

  ArrowExportToken(this.toExport, this.exportField, ArrowVM vm, String file, int line) : super(vm, file, line);

  @override
  List<String> dependencies(List<String> toIgnore) {
    return toExport.dependencies(toIgnore);
  }

  @override
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    final val = toExport.get(locals, globals, stackTrace);
    final key = exportField.get(locals, globals, stackTrace);
    vm.exports.set(key.string, val);
    return val;
  }

  @override
  String get name => "arrow:export(${toExport.name})";

  @override
  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace) {
    get(locals, globals, stackTrace);
  }

  @override
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other) {
    get(locals, globals, stackTrace);
    toExport.set(locals, globals, stackTrace, other);
  }

  @override
  ArrowToken get optimized => ArrowExportToken(toExport.optimized, exportField.optimized, vm, file, line);
}
