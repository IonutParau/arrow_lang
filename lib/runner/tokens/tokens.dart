library arrow_tokens;

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
