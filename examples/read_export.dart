import "package:arrow_lang/arrow_lang.dart";

void main() {
  final vm = ArrowVM();

  vm.loadLibs();

  vm.run('''
export 5 as "export"
''', 'arrow:example');

  print(vm.exports.get("export"));
}
