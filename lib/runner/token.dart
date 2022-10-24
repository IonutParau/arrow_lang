part of arrow_runner;

abstract class ArrowToken {
  String file;
  int line;
  ArrowVM vm;

  ArrowToken(this.vm, this.file, this.line);

  void run(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace);
  void set(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace, ArrowResource other);
  ArrowResource get(ArrowLocals locals, ArrowGlobals globals, ArrowStackTrace stackTrace);

  List<String> dependencies(List<String> toIgnore);
  ArrowToken get optimized => this;
  String get name;
}

class ArrowParsingFailure {
  String problem;
  String file;
  int line;

  ArrowParsingFailure(this.problem, this.file, this.line);

  @override
  String toString() {
    return "[Arrow Parsing Failure]\nThe problem: $problem\nIn file: $file\nAt line: ${line + 1}";
  }
}

class ArrowParsedSegment {
  String content;
  String file;
  int line;

  ArrowParsedSegment(this.content, this.file, this.line);

  @override
  String toString() {
    return "Content: $content\nFile: $file\nLine: ${line + 1}";
  }
}

class ArrowParser {
  ArrowVM vm;

  ArrowParser(this.vm);

  List<ArrowParsedSegment> splitToSegs(String code, String file, int lineOffset, List<String> seps) {
    List<ArrowParsedSegment> list = [ArrowParsedSegment("", file, lineOffset)];
    int line = lineOffset;

    final chars = code.split("");

    /// Last element is the current one, meaning the pair, with 0 being none, 1 being (), 2 being [], 3 being {}
    final List<int> bracketMode = [0];
    int bracketDepth = 0;
    bool inString = false;
    String lastChar = "";

    for (var char in chars) {
      if (char == "\"") {
        if (lastChar != "\\" || !inString) {
          inString = !inString;
        }
      }

      if (!inString) {
        if (char == "(") {
          bracketDepth++;
          bracketMode.add(1);
        }
        if (char == "[") {
          bracketDepth++;
          bracketMode.add(2);
        }
        if (char == "{") {
          bracketDepth++;
          bracketMode.add(3);
        }
        if (char == ")") {
          if (bracketMode.last != 1) {
            throw ArrowParsingFailure("Invalid Bracket Pair", file, line);
          }
          bracketDepth--;
          bracketMode.removeLast();
        }
        if (char == "]") {
          if (bracketMode.last != 2) {
            throw ArrowParsingFailure("Invalid Bracket Pair", file, line);
          }
          bracketDepth--;
          bracketMode.removeLast();
        }
        if (char == "}") {
          if (bracketMode.last != 3) {
            throw ArrowParsingFailure("Invalid Bracket Pair", file, line);
          }
          bracketDepth--;
          bracketMode.removeLast();
        }
      }

      if (char == "\n") {
        line++;
        if (list.last.content.replaceAll(" ", "").replaceAll("\t", "") == "") {
          list.last.line = line;
        }
      }

      if (bracketDepth == 0 && seps.contains(char) && !inString) {
        lastChar = char;
        list.add(ArrowParsedSegment("", file, line));
        continue;
      }

      list.last.content += char;
      lastChar = char;
    }

    return list;
  }

  int lastIndex(String code, String file, int lineOffset, List<String> lookingFor) {
    int lastIndex = -1;
    int i = 0;
    int line = lineOffset;

    final chars = code.split("");

    /// Last element is the current one, meaning the pair, with 0 being none, 1 being (), 2 being [], 3 being {}
    final List<int> bracketMode = [0];
    int bracketDepth = 0;
    bool inString = false;
    String lastChar = "";

    for (var char in chars) {
      if (char == "\"") {
        if (lastChar != "\\" || !inString) {
          inString = !inString;
        }
      }

      if (bracketDepth == 0 && lookingFor.contains(char) && !inString) {
        lastIndex = i;
      }

      if (!inString) {
        if (char == "(") {
          bracketDepth++;
          bracketMode.add(1);
        }
        if (char == "[") {
          bracketDepth++;
          bracketMode.add(2);
        }
        if (char == "{") {
          bracketDepth++;
          bracketMode.add(3);
        }
        if (char == ")") {
          if (bracketMode.last != 1) {
            throw ArrowParsingFailure("Invalid Bracket Pair", file, line);
          }
          bracketDepth--;
          bracketMode.removeLast();
        }
        if (char == "]") {
          if (bracketMode.last != 2) {
            throw ArrowParsingFailure("Invalid Bracket Pair", file, line);
          }
          bracketDepth--;
          bracketMode.removeLast();
        }
        if (char == "}") {
          if (bracketMode.last != 3) {
            throw ArrowParsingFailure("Invalid Bracket Pair", file, line);
          }
          bracketDepth--;
          bracketMode.removeLast();
        }
      }

      if (char == "\n") {
        line++;
      }

      lastChar = char;
      i++;
    }

    return lastIndex;
  }

  List<ArrowParsedSegment> splitCode(String code, String file, int lineOffset) {
    final segs = splitToSegs(code, file, lineOffset, ["\n", ";"]);

    segs.removeWhere((element) => element.content.replaceAll(" ", "").replaceAll("\t", "") == "");
    segs.removeWhere((element) => element.content.startsWith("//"));

    return segs;
  }

  List<ArrowParsedSegment> splitLine(String line, String file, int lineOffset) {
    while (line.startsWith(' ') || line.startsWith('\t')) {
      line = line.substring(1);
    }
    while (line.endsWith(' ') || line.endsWith('\t')) {
      line = line.substring(line.length - 1);
    }
    return splitToSegs(line, file, lineOffset, ["\t", " "]);
  }

  ArrowToken parseSegments(List<ArrowParsedSegment> segs, bool topLevel) {
    if (segs.length == 1) {
      final seg = segs.first;
      final file = seg.file;
      final line = seg.line;

      if (seg.content.startsWith('!')) {
        final val = parseSegments(splitLine(seg.content.substring(1), file, line), false);
        return ArrowNotToken(val, vm, file, line);
      }

      if (seg.content.startsWith('-')) {
        final val = parseSegments(splitLine(seg.content.substring(1), file, line), false);
        return ArrowSubtractionToken(ArrowNumberToken(0, vm, file, line), val, vm, file, line);
      }

      if (seg.content.startsWith('(') && seg.content.endsWith(')')) {
        final content = seg.content.substring(1, seg.content.length - 1);
        return parseSegments(splitLine(content, file, line), false);
      }

      if (seg.content.contains('(') && seg.content.endsWith(')')) {
        final i = lastIndex(seg.content, file, line, ['(']);
        final toCall = parseSegments(splitLine(seg.content.substring(0, i), file, line), false);
        final content = seg.content.substring(i + 1, seg.content.length - 1);

        if (content == "") {
          return ArrowCallToken([], toCall, vm, file, line);
        }

        final paramsTokens = splitToSegs(content, file, line, [',']).map((e) => parseSegments(splitLine(e.content, e.file, e.line), false)).toList();

        return ArrowCallToken(paramsTokens, toCall, vm, file, line);
      }

      if (num.tryParse(seg.content) != null) {
        return ArrowNumberToken(num.parse(seg.content).toDouble(), vm, file, line);
      }

      if (seg.content == "Infinity") {
        return ArrowNumberToken(double.infinity, vm, file, line);
      }
      if (seg.content == "NaN") {
        return ArrowNumberToken(double.nan, vm, file, line);
      }

      if (seg.content == "true" || seg.content == "false") {
        return ArrowBoolToken(seg.content == "true", vm, file, line);
      }

      if (["null", "undefined", "blank", "empty", "unknown", "nothing", "none", "nil"].contains(seg.content)) {
        return ArrowNullToken(vm, file, line);
      }

      if (seg.content.startsWith('"') && seg.content.endsWith('"')) {
        return ArrowStringToken(seg.content.substring(1, seg.content.length - 1), vm, file, line);
      }

      if (seg.content.startsWith('[') && seg.content.endsWith(']')) {
        final contents = seg.content.substring(1, seg.content.length - 1);
        final contentSegs = splitToSegs(contents, file, line, [',']);

        final elements = contentSegs.map((e) => parseSegments(splitLine(e.content, e.file, e.line), false)).toList();

        return ArrowListToken(elements, vm, file, line);
      }

      if (seg.content.contains('[') && seg.content.endsWith(']')) {
        final i = lastIndex(seg.content, file, line, ['[']);
        final host = parseSegments(splitLine(seg.content.substring(0, i), file, line), false);
        final field = seg.content.substring(i + 1, seg.content.length - 1);

        if (field == "") {
          return ArrowFieldToken(ArrowNullToken(vm, file, line), host, vm, file, line);
        }

        final fieldToken = parseSegments(splitLine(field, file, line), false);

        return ArrowFieldToken(fieldToken, host, vm, file, line);
      }

      if (seg.content.startsWith('{') && seg.content.endsWith('}')) {
        if (topLevel) {
          final code = splitCode(seg.content.substring(1, seg.content.length - 1), file, line);

          return ArrowBlockToken(code.map((e) => parseSegments(splitLine(e.content, e.file, e.line), true)).toList(), vm, file, line);
        } else {
          final contents = seg.content.substring(1, seg.content.length - 1);

          final contentsSegments = splitToSegs(contents, file, line, [',']);

          for (var content in contentsSegments) {
            while (content.content.startsWith(' ') || content.content.startsWith('\t')) {
              content.content = content.content.substring(1);
            }
            while (content.content.endsWith(' ') || content.content.endsWith('\t')) {
              content.content = content.content.substring(content.content.length - 1);
            }
          }

          final map = <ArrowToken, ArrowToken>{};

          for (var segment in contentsSegments) {
            final l = splitLine(segment.content, segment.file, segment.line);
            if (l.length != 3) {
              throw ArrowParsingFailure("Map pair syntax is incorrect", segment.file, segment.line);
            }
            if (l[1].content != "=") {
              throw ArrowParsingFailure("Map pair syntax is incorrect", segment.file, segment.line);
            }

            final key = l[0];
            final value = l[2];

            if (key.content.startsWith('(') && key.content.endsWith(')')) {
              map[parseSegments(splitLine(key.content.substring(1, key.content.length - 1), key.file, key.line), false)] = parseSegments(splitLine(value.content, value.file, value.line), false);
            } else {
              if (!isValidFieldName(key.content)) {
                throw ArrowParsingFailure("Forbidden field name. Either replace the field name witha raw expression (by wrapping it in parentheses) or make it like a variable name", file, line);
              }
              map[ArrowStringToken(key.content, vm, key.file, key.line)] = parseSegments(splitLine(value.content, value.file, value.line), false);
            }
          }
          return ArrowMapToken(map, vm, file, line);
        }
      }

      if (isValidVariableName(seg.content)) {
        return ArrowVariableToken(seg.content, vm, file, line);
      }

      if (seg.content.contains('.')) {
        final parts = splitToSegs(seg.content, file, line, ['.']);

        final field = parts.removeLast();
        final host = parts.map((e) => e.content).join(".");

        if (!isValidFieldName(field.content)) {
          throw ArrowParsingFailure("Forbidden field name", file, line);
        }

        return ArrowFieldToken(ArrowStringToken(field.content, vm, file, line), parseSegments(splitLine(host, file, line), false), vm, file, line);
      }
    } else {
      if (segs.length == 3) {
        // Define function
        if (segs[0].content == "fn" || segs[0].content == "fun" || segs[0].content == "function") {
          final i = segs[1].content.indexOf('(');
          if (i == -1) throw ArrowParsingFailure("Failed to find a ( in the name", segs[0].file, segs[0].line);

          final name = segs[1].content.substring(0, i);
          final params = segs[1].content.substring(i + 1, segs[1].content.length - 1).split(',');

          for (var i = 0; i < params.length; i++) {
            while (params[i].startsWith(' ') || params[i].startsWith('\t')) {
              params[i] = params[i].substring(1);
            }
          }

          final varname = parseSegments(splitLine(name, segs[2].file, segs[2].line), false);
          final body = parseSegments([segs[2]], true);

          return ArrowDefineFunctionToken(varname, params, body, vm, segs[0].file, segs[0].line);
        }
      }

      if (segs.length > 1) {
        if (segs[0].content == "return") {
          final body = parseSegments(segs.sublist(1), false);
          return ArrowReturnToken(body, vm, segs[0].file, segs[0].line);
        }
      }

      if (segs.length == 1) {
        if (segs[0].content == "return") {
          return ArrowReturnToken(ArrowNullToken(vm, segs[0].file, segs[0].line), vm, segs[0].file, segs[0].line);
        }
      }

      if (segs.length == 4) {
        if (segs[0].content == "export" && segs[2].content == "as") {
          final val = parseSegments([segs[1]], false);
          final key = parseSegments([segs[3]], false);

          return ArrowExportToken(val, key, vm, segs[0].file, segs[0].line);
        }
      }

      if (segs.length > 1) {
        if (segs[0].content == "global") {
          final name = segs[1].content;
          if (!isValidVariableName(name)) throw ArrowParsingFailure("Invalid global name", segs[1].file, segs[1].line);

          if (segs.length == 2) {
            return ArrowGlobalToken(name, ArrowVariableToken(name, vm, segs[1].file, segs[1].line), vm, segs[0].file, segs[0].line);
          }
          if (segs.length > 3) {
            if (segs[2].content == "=") {
              return ArrowGlobalToken(name, parseSegments(segs.sublist(3), false), vm, segs[0].file, segs[0].line);
            }
          }
        }
      }

      if (segs.length == 2 || segs.length > 3) {
        if (segs[0].content == "let") {
          final varname = segs[1].content;
          if (!isValidVariableName(varname)) throw ArrowParsingFailure("Invalid variable name", segs[1].file, segs[1].line);

          if (segs.length == 2) {
            return ArrowLetToken(varname, ArrowNullToken(vm, segs[1].file, segs[1].line), vm, segs[0].file, segs[0].line);
          }

          if (segs.length > 3) {
            if (segs[2].content == "=") {
              final value = parseSegments(segs.sublist(3), false);

              return ArrowLetToken(varname, value, vm, segs[0].file, segs[0].line);
            }
          }
        }
        if (segs[0].content == "set") {
          final varname = parseSegments([segs[1]], false);

          if (segs.length == 2) {
            return ArrowSetToken(varname, ArrowNullToken(vm, segs[1].file, segs[1].line), vm, segs[0].file, segs[0].line);
          }

          if (segs.length > 3) {
            if (segs[2].content == "=") {
              final value = parseSegments(segs.sublist(3), false);

              return ArrowSetToken(varname, value, vm, segs[0].file, segs[0].line);
            }
          }
        }
      }

      if (segs.length == 2) {
        if (segs[0].content.startsWith('if(') && segs[0].content.endsWith(')')) {
          final i = segs[0].content.indexOf('(');
          final name = segs[0].content.substring(i + 1, segs[0].content.length - 1);

          final condition = parseSegments(splitLine(name, segs[0].file, segs[0].line), false);

          final body = parseSegments([segs[1]], true);

          return ArrowIfToken(condition, body, vm, segs[0].file, segs[0].line);
        }
      }

      if (segs.length > 1) {
        if (segs[0].content.startsWith('while(') && segs[0].content.endsWith(')')) {
          final i = segs[0].content.indexOf('(');
          final name = segs[0].content.substring(i + 1, segs[0].content.length - 1);

          final condition = parseSegments(splitLine(name, segs[0].file, segs[0].line), false);

          final body = parseSegments(segs.sublist(1), true);

          return ArrowWhileToken(condition, body, vm, segs[0].file, segs[0].line);
        }

        if (segs[0].content.startsWith('for(') && segs[0].content.endsWith(')')) {
          final i = segs[0].content.indexOf('(');
          final name = segs[0].content.substring(i + 1, segs[0].content.length - 1);

          final nameSegs = splitLine(name, segs[0].file, segs[0].line);
          final body = parseSegments(segs.sublist(1), true);

          if (nameSegs.length == 3 || nameSegs.length == 5) {
            if (nameSegs.length == 3 && nameSegs[1].content == "in") {
              final varname = nameSegs[0].content;

              if (!isValidFieldName(varname)) throw ArrowParsingFailure("Invalid variable name for value store", nameSegs[0].file, nameSegs[0].line);

              return ArrowForToken(varname, parseSegments([nameSegs[2]], false), body, vm, segs[0].file, segs[0].line);
            }
            if (nameSegs.length == 5 && nameSegs[1].content == "at" && nameSegs[3].content == "in") {
              final varname = nameSegs[0].content;
              final atname = nameSegs[2].content;

              if (!isValidFieldName(varname)) throw ArrowParsingFailure("Invalid variable name for value store", nameSegs[0].file, nameSegs[0].line);
              if (!isValidFieldName(atname)) throw ArrowParsingFailure("Invalid variable name for index store", nameSegs[2].file, nameSegs[2].line);

              return ArrowForAtToken(varname, atname, parseSegments([nameSegs[4]], false), body, vm, segs[0].file, segs[0].line);
            }
          }
        }
      }

      if (segs.length > 3) {
        if (segs[0].content.startsWith('if(') && segs[0].content.endsWith(')') && segs[2].content == 'else') {
          final i = segs[0].content.indexOf('(');
          final name = segs[0].content.substring(i + 1, segs[0].content.length - 1);

          final condition = parseSegments(splitLine(name, segs[0].file, segs[0].line), false);

          final body = parseSegments([segs[1]], true);

          final fallback = parseSegments(segs.sublist(3), true);

          return ArrowIfElseToken(condition, body, fallback, vm, segs[0].file, segs[0].line);
        }
      }

      // Odd amount of segments might mean we're gonna do math and checking
      if (segs.length % 2 == 1) {
        final parts = <dynamic>[...segs];
        var mutated = true;
        var order = <List<String>>[
          ["^"],
          ["*", "/", "%"],
          ["+", "-"],
          ["==", "!=", ">", "<", ">=", "<="],
          ["&&", "||"],
        ];

        while (mutated) {
          mutated = false;

          for (var ops in order) {
            var i = parts.length - 1;
            while (i >= 0) {
              var op = parts[i];

              if (op is ArrowParsedSegment) {
                if (ops.contains(op.content)) {
                  final li = i - 1;
                  final ri = i + 1;

                  if (li < 0) {
                    throw ArrowParsingFailure("Nothing on the left of the ${op.content} operator!", op.file, op.line);
                  }
                  if (ri >= parts.length) {
                    throw ArrowParsingFailure("Nothing on the right of the ${op.content} operator!", op.file, op.line);
                  }
                  final l = parts[li] is ArrowToken ? parts[li] as ArrowToken : parseSegments([parts[li]], false);
                  final r = parts[ri] is ArrowToken ? parts[ri] as ArrowToken : parseSegments([parts[ri]], false);
                  if (op.content == "^") {
                    parts[li] = ArrowExpToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "*") {
                    parts[li] = ArrowMultiplyToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "/") {
                    parts[li] = ArrowDivideToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "%") {
                    parts[li] = ArrowModToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "+") {
                    parts[li] = ArrowAdditionToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "-") {
                    parts[li] = ArrowSubtractionToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "&&") {
                    parts[li] = ArrowAndToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "||") {
                    parts[li] = ArrowOrToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == ">") {
                    parts[li] = ArrowGreaterToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "<") {
                    parts[li] = ArrowLessToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == ">=") {
                    parts[li] = ArrowGreaterEqualToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "<=") {
                    parts[li] = ArrowLessEqualToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "==") {
                    parts[li] = ArrowEqualToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                  if (op.content == "!=") {
                    parts[li] = ArrowNotEqualToken(l, r, vm, op.file, op.line);
                    parts.removeAt(i);
                    parts.removeAt(i);
                    mutated = true;
                    break;
                  }
                }
              }
              i--;
            }
            if (mutated) break;
          }

          if (!mutated) break;
        }

        if (parts.length == 1) {
          if (parts[0] is ArrowToken) {
            return parts[0] as ArrowToken;
          }
        }
      }
    }

    throw ArrowParsingFailure("Unknown syntax... did you make a typo?", segs[0].file, segs[0].line);
  }

  List<String> variableAlphabet = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789_".split("");

  bool isValidVariableName(String name) {
    final chars = name.split("");

    for (var char in chars) {
      if (!variableAlphabet.contains(char)) {
        return false;
      }
    }

    if (num.tryParse(name) != null) return false;
    if (name == "") return false;
    if (["null", "undefined", "blank", "empty", "unknown", "nothing", "none", "nil"].contains(name)) return false;
    if (["true", "false"].contains(name)) return false;
    if (["NaN", "Infinity"].contains(name)) return false;

    return true;
  }

  bool isValidFieldName(String name) {
    final chars = name.split("");

    for (var char in chars) {
      if (!variableAlphabet.contains(char)) {
        return false;
      }
    }

    if (num.tryParse(name) != null) return false;
    if (name == "") return false;

    return true;
  }
}
