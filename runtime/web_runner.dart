import 'dart:html';
import 'package:arrow_lang/arrow_lang.dart';

void main() {
  final input = document.querySelector('.code') as InputElement;
  final vm = ArrowVM();

  input.onSubmit.listen(
    (event) {
      vm.run(input.text ?? "", "arrow:shell");
    },
  );
}
