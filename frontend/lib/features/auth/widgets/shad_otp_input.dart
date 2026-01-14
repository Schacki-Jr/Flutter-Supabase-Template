import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShadOtpInput extends StatefulWidget {
  final int length;
  final void Function(String code)? onCompleted;
  final void Function(String code)? onChanged;
  final bool autoSubmit;

  const ShadOtpInput({
    super.key,
    this.length = 6,
    this.onCompleted,
    this.onChanged,
    this.autoSubmit = true,
  });

  @override
  State<ShadOtpInput> createState() => _ShadOtpInputState();
}

class _ShadOtpInputState extends State<ShadOtpInput> {
  late final List<TextEditingController> _controllers;
  late final List<FocusNode> _nodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(widget.length, (_) => TextEditingController());
    _nodes = List.generate(widget.length, (_) => FocusNode());
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final n in _nodes) {
      n.dispose();
    }
    super.dispose();
  }

  void _notify() {
    final code = _controllers.map((c) => c.text).join();
    widget.onChanged?.call(code);
    if (widget.autoSubmit &&
        code.length == widget.length &&
        !code.contains(RegExp(r"[^0-9]"))) {
      widget.onCompleted?.call(code);
    }
  }

  Future<void> _handlePasteFrom(int startIndex) async {
    final data = await Clipboard.getData(Clipboard.kTextPlain);
    final text = data?.text ?? '';
    if (!mounted) return;
    if (text.isEmpty) return;
    final chars = text.replaceAll(RegExp(r'\D'), '').split('');
    if (chars.isEmpty) return;
    int j = 0;
    for (int i = startIndex; i < widget.length && j < chars.length; i++, j++) {
      if (!mounted) return;
      _controllers[i].text = chars[j];
    }
    if (!mounted) return;
    final nextIndex = (startIndex + chars.length).clamp(0, widget.length - 1);
    _nodes[nextIndex].requestFocus();
    _notify();
  }

  @override
  Widget build(BuildContext context) {
    final borderColor = Theme.of(context).colorScheme.outlineVariant;
    final focusColor = Theme.of(context).colorScheme.primary;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(widget.length, (i) {
        return SizedBox(
          width: 44,
          child: KeyboardListener(
            focusNode: FocusNode(skipTraversal: true),
            onKeyEvent: (event) async {
              if (event is! KeyDownEvent) return;
              if (event.logicalKey == LogicalKeyboardKey.backspace) {
                if (_controllers[i].text.isEmpty && i > 0) {
                  _controllers[i - 1].text = '';
                  _nodes[i - 1].requestFocus();
                } else {
                  _controllers[i].text = '';
                }
                _notify();
              }
              // Detect paste (Cmd/Ctrl + V)
              final keys = HardwareKeyboard.instance.logicalKeysPressed;
              final isCtrl = keys.contains(LogicalKeyboardKey.controlLeft) ||
                  keys.contains(LogicalKeyboardKey.controlRight);
              final isMeta = keys.contains(LogicalKeyboardKey.metaLeft) ||
                  keys.contains(LogicalKeyboardKey.metaRight);
              if ((isCtrl || isMeta) &&
                  event.logicalKey == LogicalKeyboardKey.keyV) {
                await _handlePasteFrom(i);
              }
            },
            child: TextField(
              controller: _controllers[i],
              focusNode: _nodes[i],
              autofocus: i == 0,
              textAlign: TextAlign.center,
              maxLength: 1,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: '',
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: borderColor),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: focusColor, width: 2),
                ),
              ),
              onChanged: (val) {
                // Handle paste: if multiple chars, distribute
                if (val.length > 1) {
                  final chars = val.replaceAll(RegExp(r'\D'), '').split('');
                  for (int j = 0;
                      j < chars.length && (i + j) < widget.length;
                      j++) {
                    _controllers[i + j].text = chars[j];
                  }
                  final nextIndex =
                      (i + chars.length).clamp(0, widget.length - 1);
                  _nodes[nextIndex].requestFocus();
                } else {
                  // Single char typed
                  if (val.isNotEmpty && i < widget.length - 1) {
                    _nodes[i + 1].requestFocus();
                  } else if (val.isEmpty && i > 0) {
                    _nodes[i - 1].requestFocus();
                  }
                }
                _notify();
              },
            ),
          ),
        );
      }),
    );
  }
}
