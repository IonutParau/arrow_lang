import 'package:arrow_lang/arrow_lang.dart';
import 'package:arrow_lang/runner/tokens/tokens.dart';
import 'package:test/test.dart';

void main() {
  test('string processing', () {
    final str = ArrowStringToken("Test\\nThis\\nThing\\tNow\\n\\\\", ArrowVM(), "arrow:test", 0);
    expect(str.str, "Test\nThis\nThing\tNow\n\\");
  });
}
