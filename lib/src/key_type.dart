part of virtual_keyboard;

/// Type for virtual keyboard key.
///
/// `Action` - Can be action key - Return, Backspace, etc.
///
/// `String` - Keys that have text value - `Letters`, `Numbers`, `@` `.`
/// `Blank` - Keys that simply add space in the row
enum VirtualKeyboardKeyType { Action, String, Blank }
