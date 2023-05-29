part of virtual_keyboard;

/// The default keyboard height. Can we overriden by passing
///  `height` argument to `VirtualKeyboard` widget.
const double _virtualKeyboardDefaultHeight = 300;

const int _virtualKeyboardBackspaceEventPerioud = 250;

/// Virtual Keyboard widget.
class VirtualKeyboard extends StatefulWidget {
  /// Keyboard Type: Should be inited in creation time.
  final VirtualKeyboardType type;

  /// Callback for Key press event. Called with pressed `Key` object.
  final Function onKeyPress;

  /// Virtual keyboard height. Default is 300
  final double height;

  /// Color for key texts and icons.
  final Color textColor;

  /// Color for the key ripple effect
  final Color rippleColor;

  /// Font size for keyboard keys.
  final double fontSize;

  /// shadow color
  final Color shadowColor;

  /// The builder function will be called for each Key object.
  final Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;

  final Widget Function(BuildContext context) backspaceImageBuilder;

  /// Set to true if you want only to show Caps letters.
  final bool alwaysCaps;

  /// Set to true to all Haptic feedback on Tap
  final bool enableFeedback;
  final TextStyle? customStyle;

  VirtualKeyboard({
    required this.type,
    required this.onKeyPress,
    required this.backspaceImageBuilder,
    this.builder,
    this.height = _virtualKeyboardDefaultHeight,
    this.textColor = Colors.black,
    this.rippleColor = Colors.transparent,
    this.fontSize = 14,
    this.alwaysCaps = false,
    this.enableFeedback = true,
    this.customStyle,
    required this.shadowColor,
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _VirtualKeyboardState();
  }
}

/// Holds the state for Virtual Keyboard class.
class _VirtualKeyboardState extends State<VirtualKeyboard> {
  late VirtualKeyboardType type;
  late Function onKeyPress;
  // The builder function will be called for each Key object.
  late Widget Function(BuildContext context, VirtualKeyboardKey key)? builder;
  late double height;
  late Color textColor;
  late Color rippleColor;
  late double fontSize;
  late bool alwaysCaps;
  late bool enableFeedback;
  late Color shadowColor;
  // Text Style for keys.
  late TextStyle textStyle;

  // True if shift is enabled.
  bool isShiftEnabled = false;

  @override
  void didUpdateWidget(VirtualKeyboard oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() {
      type = widget.type;
      onKeyPress = widget.onKeyPress;
      height = widget.height;
      textColor = widget.textColor;
      rippleColor = widget.rippleColor;
      fontSize = widget.fontSize;
      alwaysCaps = widget.alwaysCaps;
      enableFeedback = widget.enableFeedback;
      shadowColor = widget.shadowColor;
      builder = widget.builder;
      // Init the Text Style for keys.
      textStyle = widget.customStyle ??
          TextStyle(
            fontSize: fontSize,
            color: textColor,
          );
    });
  }

  @override
  void initState() {
    super.initState();

    type = widget.type;
    onKeyPress = widget.onKeyPress;
    height = widget.height;
    textColor = widget.textColor;
    rippleColor = widget.rippleColor;
    fontSize = widget.fontSize;
    alwaysCaps = widget.alwaysCaps;
    enableFeedback = widget.enableFeedback;
    builder = widget.builder;
    shadowColor = widget.shadowColor;
    // Init the Text Style for keys.
    textStyle = widget.customStyle ??
        TextStyle(
          fontSize: fontSize,
          color: textColor,
        );
  }

  @override
  Widget build(BuildContext context) {
    return type == VirtualKeyboardType.Numeric ? _numeric() : _alphanumeric();
  }

  Widget _alphanumeric() {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  Widget _numeric() {
    return Container(
      height: height,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _rows(),
      ),
    );
  }

  /// Returns the rows for keyboard.
  List<Widget> _rows() {
    // Get the keyboard Rows
    List<List<VirtualKeyboardKey>> keyboardRows =
        type == VirtualKeyboardType.Numeric
            ? _getKeyboardRowsNumeric()
            : _getKeyboardRows();

    // Generate keyboard row.
    List<Widget> rows = List.generate(keyboardRows.length, (int rowNum) {
      return Material(
        color: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          // Generate keboard keys
          children: List.generate(
            keyboardRows[rowNum].length,
            (int keyNum) {
              // Get the VirtualKeyboardKey object.
              VirtualKeyboardKey virtualKeyboardKey =
                  keyboardRows[rowNum][keyNum];

              Widget keyWidget;

              // Check if builder is specified.
              // Call builder function if specified or use default
              //  Key widgets if not.
              if (widget.builder == null) {
                // Check the key type.
                switch (virtualKeyboardKey.keyType) {
                  case VirtualKeyboardKeyType.String:
                    // Draw String key.
                    keyWidget = _keyboardDefaultKey(virtualKeyboardKey);
                    break;
                  case VirtualKeyboardKeyType.Action:
                    // Draw action key.
                    keyWidget = _keyboardDefaultActionKey(virtualKeyboardKey);
                    break;
                }
              } else {
                // Call the builder function, so the user can specify custom UI for keys.
                keyWidget = builder!(context, virtualKeyboardKey);
              }

              return keyWidget;
            },
          ),
        ),
      );
    });

    return rows;
  }

  // True if long press is enabled.
  bool? longPress;

  /// Creates default UI element for keyboard Key.
  Widget _keyboardDefaultKey(VirtualKeyboardKey key) {
    return Expanded(
        child: Card(
      surfaceTintColor: Colors.white,
      shape: CircleBorder(),
      elevation: 2,
      color: Colors.white,
      child: InkWell(
        splashColor: Colors.transparent,
        enableFeedback: enableFeedback,
        customBorder: CircleBorder(),
        onTap: () {
          if (enableFeedback) {
            HapticFeedback.lightImpact();
          }
          onKeyPress(key);
        },
        child: Container(
          height: height / _keyRows.length,
          // height: height/ ,
          // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 16),
          child: Center(
            child: Text(
              alwaysCaps
                  ? key.capsText ?? ''
                  : (isShiftEnabled ? key.capsText : key.text) ?? '',
              style: textStyle,
            ),
          ),
        ),
      ),
    ));
  }

  /// Creates default UI element for keyboard Action Key.
  Widget _keyboardDefaultActionKey(VirtualKeyboardKey key) {
    // Holds the action key widget.
    Widget actionKey;

    // Switch the action type to build action Key widget.
    switch (key.action) {
      case null:
      case VirtualKeyboardKeyAction.Backspace:
        actionKey = GestureDetector(
          onLongPress: () {
            longPress = true;
            // Start sending backspace key events while longPress is true
            Timer.periodic(
                Duration(milliseconds: _virtualKeyboardBackspaceEventPerioud),
                (timer) {
              if (longPress!) {
                onKeyPress(key);
              } else {
                // Cancel timer.
                timer.cancel();
              }
            });
          },
          onLongPressUp: () {
            // Cancel event loop
            longPress = false;
          },
          child: Container(
            height: double.infinity,
            width: double.infinity,
            child: Center(
                child: widget.backspaceImageBuilder != null
                    ? widget.backspaceImageBuilder(context)
                    : Icon(
                        Icons.backspace,
                        color: textColor,
                      )),
          ),
        );
        break;
      case VirtualKeyboardKeyAction.Shift:
        actionKey = Icon(Icons.arrow_upward, color: textColor);
        break;
      case VirtualKeyboardKeyAction.Space:
        actionKey = actionKey = Icon(Icons.space_bar, color: textColor);
        break;
      case VirtualKeyboardKeyAction.Return:
        actionKey = Icon(
          Icons.keyboard_return,
          color: textColor,
        );
        break;
    }

    return Expanded(
      child: Card(
        surfaceTintColor: Colors.white,
        shape: CircleBorder(),
        elevation: 2,
        color: Colors.white,
        child: InkWell(
          enableFeedback: enableFeedback,
          customBorder: CircleBorder(),
          splashColor: Colors.transparent,
          onTap: () {
            if (enableFeedback) {
              HapticFeedback.lightImpact();
            }
            if (key.action == VirtualKeyboardKeyAction.Shift) {
              if (!alwaysCaps) {
                setState(() {
                  isShiftEnabled = !isShiftEnabled;
                });
              }
            }

            onKeyPress(key);
          },
          child: Container(
            alignment: Alignment.center,
            height: height / _keyRows.length,
            child: actionKey,
          ),
        ),
      ),
    );
  }
}
