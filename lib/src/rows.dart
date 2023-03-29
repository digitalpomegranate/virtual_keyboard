part of virtual_keyboard;

/// Keys for Virtual Keyboard's rows.
const List<List> _keyRows = [
  // Row 1
  const [
    '1',
    '2',
    '3',
    '4',
    '5',
    '6',
    '7',
    '8',
    '9',
    '0',
  ],
  // Row 2
  const [
    'q',
    'w',
    'e',
    'r',
    't',
    'y',
    'u',
    'i',
    'o',
    'p',
  ],
  // Row 3
  const [
    'a',
    's',
    'd',
    'f',
    'g',
    'h',
    'j',
    'k',
    'l',
    ';',
    '\'',
  ],
  // Row 4
  const [
    'z',
    'x',
    'c',
    'v',
    'b',
    'n',
    'm',
    ',',
    '.',
    '/',
  ],
  // Row 5
  const [
    '@',
    '_',
  ]
];

/// Keys for Virtual Keyboard's rows with a period in the lower left row.
const List<List> _keyRowsNumericPeriod = [
  // Row 1
  const [
    '1',
    '2',
    '3',
  ],
  // Row 1
  const [
    '4',
    '5',
    '6',
  ],
  // Row 1
  const [
    '7',
    '8',
    '9',
  ],
  // Row 1
  const [
    '.',
    '0',
  ],
];

/// Keys for Virtual Keyboard's rows with a double zeros in the lower left row.
const List<List> _keyRowsNumericDoubleZero = [
  // Row 1
  const [
    '1',
    '2',
    '3',
  ],
  // Row 1
  const [
    '4',
    '5',
    '6',
  ],
  // Row 1
  const [
    '7',
    '8',
    '9',
  ],
  // Row 1
  const [
    '00',
    '0',
  ],
];


/// Returns a list of `VirtualKeyboardKey` objects for Numeric keyboard.
List<VirtualKeyboardKey> _getKeyboardRowKeysNumeric(int rowNum, NumberLowerLeftKeyType lowerLeftKeyType) {
  // Generate VirtualKeyboardKey objects for each row.

  switch (lowerLeftKeyType) {
    case NumberLowerLeftKeyType.Period:
      return List.generate(_keyRowsNumericPeriod[rowNum].length, (int keyNum) {
        // Get key string value.
        String key = _keyRowsNumericPeriod[rowNum][keyNum];

        // Create and return new VirtualKeyboardKey object.
        return VirtualKeyboardKey(
          text: key,
          capsText: key.toUpperCase(),
          keyType: VirtualKeyboardKeyType.String,
        );
      });
    case NumberLowerLeftKeyType.DoubleZero:
      return List.generate(_keyRowsNumericDoubleZero[rowNum].length, (int keyNum) {
        // Get key string value.
        String key = _keyRowsNumericDoubleZero[rowNum][keyNum];

        // Create and return new VirtualKeyboardKey object.
        return VirtualKeyboardKey(
          text: key,
          capsText: key.toUpperCase(),
          keyType: VirtualKeyboardKeyType.String,
        );
      });
  }
}

/// Returns a list of `VirtualKeyboardKey` objects.
List<VirtualKeyboardKey> _getKeyboardRowKeys(rowNum) {
  // Generate VirtualKeyboardKey objects for each row.
  return List.generate(_keyRows[rowNum].length, (int keyNum) {
    // Get key string value.
    String key = _keyRows[rowNum][keyNum];

    // Create and return new VirtualKeyboardKey object.
    return VirtualKeyboardKey(
      text: key,
      capsText: key.toUpperCase(),
      keyType: VirtualKeyboardKeyType.String,
    );
  });
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRows() {
  // Generate lists for each keyboard row.
  return List.generate(_keyRows.length, (int rowNum) {
    // Will contain the keyboard row keys.
    List<VirtualKeyboardKey> rowKeys = [];

    // We have to add Action keys to keyboard.
    switch (rowNum) {
      case 1:
        // String keys.
        rowKeys = _getKeyboardRowKeys(rowNum);

        // 'Backspace' button.
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Backspace),
        );
        break;
      case 2:
        // String keys.
        rowKeys = _getKeyboardRowKeys(rowNum);

        // 'Return' button.
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Return,
              text: '\n',
              capsText: '\n'),
        );
        break;
      case 3:
        // Left Shift
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Shift),
        );

        // String keys.
        rowKeys.addAll(_getKeyboardRowKeys(rowNum));

        // Right Shift
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Shift),
        );
        break;
      case 4:
        // String keys.
        rowKeys = _getKeyboardRowKeys(rowNum);

        // Insert the space key into second position of row.
        rowKeys.insert(
          1,
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              text: ' ',
              capsText: ' ',
              action: VirtualKeyboardKeyAction.Space),
        );

        break;
      default:
        rowKeys = _getKeyboardRowKeys(rowNum);
    }

    return rowKeys;
  });
}

int _listNumericLength(NumberLowerLeftKeyType lowerLeftKeyType) {
  switch (lowerLeftKeyType) {
    case NumberLowerLeftKeyType.Period:
      return _keyRowsNumericPeriod.length;
    case NumberLowerLeftKeyType.DoubleZero:
      return _keyRowsNumericDoubleZero.length;
  }
}

/// Returns a list of VirtualKeyboard rows with `VirtualKeyboardKey` objects.
List<List<VirtualKeyboardKey>> _getKeyboardRowsNumeric(NumberLowerLeftKeyType lowerLeftKeyType) {
  // Generate lists for each keyboard row.
  return List.generate(_listNumericLength(lowerLeftKeyType), (int rowNum) {
    // Will contain the keyboard row keys.
    List<VirtualKeyboardKey> rowKeys = [];

    // We have to add Action keys to keyboard.
    switch (rowNum) {
      case 3:
        // String keys.
        rowKeys.addAll(_getKeyboardRowKeysNumeric(rowNum, lowerLeftKeyType));

        // Right Shift
        rowKeys.add(
          VirtualKeyboardKey(
              keyType: VirtualKeyboardKeyType.Action,
              action: VirtualKeyboardKeyAction.Backspace),
        );
        break;
      default:
        rowKeys = _getKeyboardRowKeysNumeric(rowNum, lowerLeftKeyType);
    }

    return rowKeys;
  });
}
