import 'package:arrow_lang/arrow_lang.dart';

void main() {
  // Create the VM
  final vm = ArrowVM();

  // Set a global called test to an external function (aka function that calls Dart code).
  // This external function prints the list of stringified resources.
  vm.globals.set("test", ArrowExternalFunction(((params, stackTrace) {
    print(params.map((e) => e.string).toList());
    return ArrowNull();
  })));

  vm.run('test(5, 3, 2, "Test", [5, 3, 2, 1], {test = 5, ("epic") = 29})', 'arrow:example');
}
