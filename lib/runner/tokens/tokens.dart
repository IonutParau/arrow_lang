library arrow_tokens;

import 'dart:math';

import 'package:arrow_lang/types/types.dart';

import '../runner.dart';

// Syntax for hard-coded values
part 'values/string.dart';
part 'values/number.dart';
part 'values/boolean.dart';
part 'values/null.dart';
part 'values/map.dart';
part 'values/list.dart';
part 'values/function.dart';
part 'values/class.dart';

// Syntax for field manipulation, variable manipulation and function invocation
part 'uses/call.dart';
part 'uses/field.dart';
part 'uses/variable.dart';
part 'uses/let.dart';
part 'uses/set.dart';
part 'uses/block.dart';
part 'uses/return.dart';
part 'uses/export.dart';
part 'uses/global.dart';

// Syntax for math
part 'math/add.dart';
part 'math/sub.dart';
part 'math/multiply.dart';
part 'math/divide.dart';
part 'math/mod.dart';
part 'math/exp.dart';

// Syntax for logic
part 'logic/and.dart';
part 'logic/or.dart';
part 'logic/greater.dart';
part 'logic/less.dart';
part 'logic/equal.dart';
part 'logic/not_equal.dart';
part 'logic/greater_equal.dart';
part 'logic/less_equal.dart';
part 'logic/not.dart';

// Syntax for loops and ifs
part 'codeflow/if.dart';
part 'codeflow/if_else.dart';
part 'codeflow/while.dart';
part 'codeflow/for.dart';
part 'codeflow/for_at.dart';
