import 'package:flutter_test/flutter_test.dart';

import 'package:virtual_keyboard/virtual_keyboard.dart';

void main() {
  test('creates keyboard widget with Alphanumeric type', () {
    final keyboard = VirtualKeyboard(
      type: VirtualKeyboardType.Alphanumeric,
      onKeyPress: () => null,
    );
    expect(keyboard.type, VirtualKeyboardType.Alphanumeric);
  });
}
