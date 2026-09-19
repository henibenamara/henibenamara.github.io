import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Types a word, holds it, deletes it, moves to the next. Caret blinks.
class Typewriter extends StatefulWidget {
  final List<String> words;
  final TextStyle? style;
  final Duration typeSpeed;
  final Duration deleteSpeed;
  final Duration hold;

  const Typewriter({
    super.key,
    required this.words,
    this.style,
    this.typeSpeed = const Duration(milliseconds: 70),
    this.deleteSpeed = const Duration(milliseconds: 34),
    this.hold = const Duration(milliseconds: 1400),
  });

  @override
  State<Typewriter> createState() => _TypewriterState();
}

class _TypewriterState extends State<Typewriter>
    with SingleTickerProviderStateMixin {
  int _word = 0;
  int _chars = 0;
  bool _deleting = false;
  Timer? _timer;
  late final AnimationController _caret = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 950),
  )..repeat(reverse: true);

  @override
  void initState() {
    super.initState();
    _schedule(const Duration(milliseconds: 500));
  }

  void _schedule(Duration d) {
    _timer?.cancel();
    _timer = Timer(d, _step);
  }

  void _step() {
    if (!mounted || widget.words.isEmpty) return;
    final String current = widget.words[_word % widget.words.length];
    if (_deleting) {
      if (_chars == 0) {
        _deleting = false;
        _word = (_word + 1) % widget.words.length;
        _schedule(widget.typeSpeed);
      } else {
        setState(() => _chars--);
        _schedule(widget.deleteSpeed);
      }
    } else {
      if (_chars >= current.length) {
        _deleting = true;
        _schedule(widget.hold);
      } else {
        setState(() => _chars++);
        _schedule(widget.typeSpeed);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _caret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final String current =
        widget.words.isEmpty ? '' : widget.words[_word % widget.words.length];
    final String shown = current.substring(0, _chars.clamp(0, current.length));
    final TextStyle style =
        widget.style ?? Theme.of(context).textTheme.headlineSmall!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Text(shown, style: style),
        const SizedBox(width: 4),
        FadeTransition(
          opacity: _caret,
          child: Container(
            width: 3,
            height: (style.fontSize ?? 20) * 1.1,
            decoration: BoxDecoration(
              color: c.accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
      ],
    );
  }
}
