import 'package:arrow_lang/arrow_lang.dart';

void main() {
  final vm = ArrowVM();

  vm.loadLibs();

  vm.run('global G = true', 'arrow:external');

  print(vm.globals.get("G"));
}
