import 'package:arrow_lang/arrow_lang.dart';

void main() {
  final vm = ArrowVM(); // Create VM
  vm.loadLibs(); // Load libraries (we need the terminal library to use print)

  // Run some code. We need to specify the file name as well in case of a crash.
  // This can throw ArrowParsingErrors or ArrowStackTraceElements, the former meaning a syntax error and the latter meaning an unrecoverable runtime error.
  vm.run(r'''
    print("Hello, world!")
  ''', "arrow:example");
}
