part of virtual_keyboard;

/// Available Virtual Keyboard Types:
/// `Numeric` - Numeric only.
/// `Alphanumeric` - Alphanumeric: letters`[A-Z]` + numbers`[0-9]` + `@` + `.`.
enum VirtualKeyboardType { Numeric, Alphanumeric }

/// If using the Numeric keypad, you can pass in the DoubleZero to get a 00 key like a cash drawer page.
/// Period is the default Key.
///
enum NumberLowerLeftKeyType { Period, DoubleZero }
