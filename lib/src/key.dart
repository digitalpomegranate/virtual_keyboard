part of virtual_keyboard;

/// Virtual Keyboard key
class VirtualKeyboardKey {
  final String? text;
  final String? capsText;
  final VirtualKeyboardKeyAction? action;
  final VirtualKeyboardKeyType keyType;

  VirtualKeyboardKey({
    this.text,
    this.capsText,
    required this.keyType,
    this.action,
  });
}
