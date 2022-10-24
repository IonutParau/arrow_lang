# Arrow

A scripting language written in <a href="https://dart.dev/">Dart</a> meant for embedding into Dart programs with a simple, clean API

# Syntax

The syntax is heavily influenced by languages such as JavaScript.

```js
// Line breaks are significant!
// They tell the parser its a new instruction!
// If you want multiple instructions on one line, seperate them with a ;

// Define a local
let name = 5

// This makes name have its value exported into the Exports table of the VM.
// This isn't like a global, the VM doesn't read its exports. Only the embedder is meant to read exports via helper functions.
export name as "name";

// Define a local function
function test() {
  return name
}

// Globalize a variable
global test;

// Set a variable (global or local)
name += 2

// Define a global (set also defines if the global doesnt exist, but this one forcefully uses the global)
global name = "Test"

// This makes the VM itself return some value
return [5, 123, 789]
```

# Embedding

Arrow is really easy to embed into Dart applications.

```dart
import "package:arrow_lang/arrow_lang.dart";

void main() {
  // Create a VM instance
  final vm = ArrowVM();

  // Load built-in libraries
  vm.loadLibs();

  // Run a file
  final result = vm.runFile(File("code.arw"));

  // Read a global from the VM
  print(vm.globals.get("Some global"));

  // Modify a global inside of the VM
  vm.globals.set("Some global", ArrowNumber(42));

  // Get an export
  final someExportedValue = vm.exports.get("Some export");
}
```

You can look in the `examples` folder for more examples.
