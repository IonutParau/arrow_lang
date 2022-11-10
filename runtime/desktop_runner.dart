import 'dart:io';

import 'package:arrow_lang/arrow_lang.dart';

enum ArgType { string, number, int, bool }

Map<String, dynamic> parseArgs(List<String> args, Map<String, ArgType> types) {
  final argsMap = <String, dynamic>{};
  int i = 0;

  for (var arg in args) {
    if (arg.startsWith("--") && arg.contains("=")) {
      final name = arg.split("=").first.substring(2);
      final val = arg.split("=").sublist(1).join("=");

      final type = types[name] ?? ArgType.string;

      if (type == ArgType.string) {
        if (val.startsWith("\"") && val.endsWith("\"")) {
          argsMap[name] = val.substring(1, val.length - 1);
        } else {
          argsMap[name] = val;
        }
      }
      if (type == ArgType.bool) {
        argsMap[name] = val == "true";
      }
      if (type == ArgType.number) {
        argsMap[name] = double.parse(val);
      }
      if (type == ArgType.int) {
        argsMap[name] = int.parse(val);
      }
    } else if (arg.startsWith('--')) {
      final name = arg.substring(2);
      final type = types[name] ?? ArgType.bool;

      if (type == ArgType.bool) {
        argsMap[name] = true;
      }
    } else {
      final name = i.toString();
      final val = arg;

      final type = types[name] ?? ArgType.string;

      if (type == ArgType.string) {
        if (val.startsWith("\"") && val.endsWith("\"")) {
          argsMap[name] = val.substring(1, val.length - 1);
        } else {
          argsMap[name] = val;
        }
      }
      if (type == ArgType.bool) {
        argsMap[name] = val == "true";
      }
      if (type == ArgType.number) {
        argsMap[name] = double.parse(val);
      }
      if (type == ArgType.int) {
        argsMap[name] = int.parse(val);
      }
      i++;
    }
  }

  return argsMap;
}

void main(List<String> args) {
  final parsedArgs = parseArgs(args, {"libs": ArgType.string, "0": ArgType.string, "debug": ArgType.bool});

  final vm = ArrowVM();

  if (parsedArgs.containsKey("libs")) {
    vm.loadLibs([parsedArgs["libs"].split(":")]);
  } else {
    vm.loadLibs();
  }

  bool log = parsedArgs["debug"] ?? false;

  if (parsedArgs.containsKey("0")) {
    vm.runFile(File(parsedArgs["0"]!));
    if (log) {
      print("Globals: ${vm.globals.toString()}");
      print("Exports: ${vm.exports.toString()}");
      print("Deepest Stack Trace: ${vm.stackTrace.deepest}");
    }
  } else {
    while (true) {
      stdout.write('ArrowVM > ');
      final input = stdin.readLineSync();
      if (input == "exit") {
        if (log) {
          print("Globals: ${vm.globals.toString()}");
          print("Exports: ${vm.exports.toString()}");
          print("Deepest Stack Trace: ${vm.stackTrace.deepest}");
        }
        return;
      }
      if (input != null) {
        try {
          vm.run(input, "term:userInput");
          if (vm.locals.has("")) {
            if (log) {
              print("Globals: ${vm.globals.toString()}");
              print("Exports: ${vm.exports.toString()}");
              print("Deepest Stack Trace: ${vm.stackTrace.deepest}");
            }
            return;
          }
        } catch (e, stack) {
          print(e);
          print(stack);
        }
      }
    }
  }
}
