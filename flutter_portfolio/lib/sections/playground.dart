import 'package:flutter/material.dart';
import '../core/responsive.dart';
import '../theme/app_theme.dart';
import '../widgets/glass.dart';
import '../widgets/reveal.dart';
import '../widgets/section_shell.dart';

/// The proof-of-skill section: the visitor moves sliders, a real widget tree
/// rebuilds live, the animation curve is plotted as it plays, and the Dart
/// code that would produce exactly what they see is generated next to it.
class PlaygroundSection extends StatefulWidget {
  const PlaygroundSection({super.key});

  @override
  State<PlaygroundSection> createState() => _PlaygroundSectionState();
}

class _PlaygroundSectionState extends State<PlaygroundSection>
    with SingleTickerProviderStateMixin {
  double _radius = 26;
  double _blur = 34;
  double _hue = 205;
  double _travel = 90;
  double _ms = 900;
  bool _gradient = true;
  bool _spin = true;
  int _curve = 2;
  bool _playing = true;

  static const List<String> _curveNames = <String>[
    'Curves.linear',
    'Curves.easeOutCubic',
    'Curves.fastOutSlowIn',
    'Curves.easeOutBack',
    'Curves.elasticOut',
    'Curves.bounceOut',
  ];

  static const List<Curve> _curves = <Curve>[
    Curves.linear,
    Curves.easeOutCubic,
    Curves.fastOutSlowIn,
    Curves.easeOutBack,
    Curves.elasticOut,
    Curves.bounceOut,
  ];

  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: Duration(milliseconds: _ms.round()),
  );

  @override
  void initState() {
    super.initState();
    _c.repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _setDuration(double ms) {
    _ms = ms;
    _c.duration = Duration(milliseconds: ms.round());
    if (_playing) {
      _c.stop();
      _c.repeat(reverse: true);
    }
  }

  void _togglePlay() {
    setState(() {
      _playing = !_playing;
      if (_playing) {
        _c.repeat(reverse: true);
      } else {
        _c.stop();
      }
    });
  }

  void _reset() {
    setState(() {
      _radius = 26;
      _blur = 34;
      _hue = 205;
      _travel = 90;
      _gradient = true;
      _spin = true;
      _curve = 2;
      _setDuration(900);
    });
  }

  Color get _color => HSLColor.fromAHSL(1, _hue, 0.72, 0.56).toColor();
  Color get _color2 =>
      HSLColor.fromAHSL(1, (_hue + 58) % 360, 0.70, 0.62).toColor();

  String get _code {
    final String grad = _gradient
        ? 'LinearGradient(\n        colors: <Color>[color, colorShifted],\n      )'
        : 'null';
    return '''AnimatedBuilder(
  animation: controller, // ${_ms.round()}ms, repeat(reverse: true)
  builder: (context, _) {
    final t = ${_curveNames[_curve]}.transform(controller.value);
    return Transform(
      transform: Matrix4.identity()
        ..translate(${_travel.round()}.0 * (t - 0.5) * 2)${_spin ? '\n        ..rotateZ(t * 0.5)' : ''},
      alignment: Alignment.center,
      child: Container(
        width: 108,
        height: 108,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(${_radius.round()}),
          color: ${_gradient ? 'null' : 'HSLColor.fromAHSL(1, ${_hue.round()}, .72, .56).toColor()'},
          gradient: $grad,
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: color.withOpacity(0.45),
              blurRadius: ${_blur.round()},
              offset: const Offset(0, 14),
            ),
          ],
        ),
      ),
    );
  },
)''';
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = context.isMobile;
    final Widget controls = _Controls(
      radius: _radius,
      blur: _blur,
      hue: _hue,
      travel: _travel,
      ms: _ms,
      gradient: _gradient,
      spin: _spin,
      curve: _curve,
      playing: _playing,
      curveNames: _curveNames,
      onRadius: (double v) => setState(() => _radius = v),
      onBlur: (double v) => setState(() => _blur = v),
      onHue: (double v) => setState(() => _hue = v),
      onTravel: (double v) => setState(() => _travel = v),
      onMs: (double v) => setState(() => _setDuration(v)),
      onGradient: (bool v) => setState(() => _gradient = v),
      onSpin: (bool v) => setState(() => _spin = v),
      onCurve: (int v) => setState(() => _curve = v),
      onPlay: _togglePlay,
      onReset: _reset,
    );

    final Widget stage = Column(
      children: <Widget>[
        _Stage(
          controller: _c,
          curve: _curves[_curve],
          radius: _radius,
          blur: _blur,
          travel: _travel,
          spin: _spin,
          gradient: _gradient,
          color: _color,
          color2: _color2,
        ),
        const SizedBox(height: 18),
        _CurveGraph(
          controller: _c,
          curve: _curves[_curve],
          label: _curveNames[_curve],
        ),
        const SizedBox(height: 18),
        _CodeBlock(code: _code),
      ],
    );

    return SectionShell(
      eyebrow: 'Try it yourself',
      title: 'Flutter playground',
      intro:
          'This is not a video and not a GIF. Move a slider and a real widget '
          'tree rebuilds in front of you - then read the Dart that produces it.',
      child: Reveal(
        dy: 40,
        child: mobile
            ? Column(
                children: <Widget>[stage, const SizedBox(height: 22), controls],
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(flex: 5, child: controls),
                  const SizedBox(width: 26),
                  Expanded(flex: 7, child: stage),
                ],
              ),
      ),
    );
  }
}

// ------------------------------------------------------------------ stage ---
class _Stage extends StatelessWidget {
  final AnimationController controller;
  final Curve curve;
  final double radius;
  final double blur;
  final double travel;
  final bool spin;
  final bool gradient;
  final Color color;
  final Color color2;

  const _Stage({
    required this.controller,
    required this.curve,
    required this.radius,
    required this.blur,
    required this.travel,
    required this.spin,
    required this.gradient,
    required this.color,
    required this.color2,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return GlassPanel(
      radius: 24,
      padding: EdgeInsets.zero,
      child: SizedBox(
        height: 250,
        child: Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(painter: _GridPainter(color: c.border)),
            ),
            Center(
              child: AnimatedBuilder(
                animation: controller,
                builder: (BuildContext context, Widget? _) {
                  final double t = curve.transform(controller.value);
                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(travel * (t - 0.5) * 2)
                      ..rotateZ(spin ? t * 0.5 : 0),
                    child: Container(
                      width: 108,
                      height: 108,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(radius),
                        color: gradient ? null : color,
                        gradient: gradient
                            ? LinearGradient(
                                colors: <Color>[color, color2],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              )
                            : null,
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: color.withOpacity(0.45),
                            blurRadius: blur,
                            offset: const Offset(0, 14),
                            spreadRadius: -4,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          Icons.flutter_dash,
                          color: Colors.white.withOpacity(0.92),
                          size: 44,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            Positioned(
              left: 14,
              top: 12,
              child: Text(
                'live widget',
                style: Theme.of(context)
                    .textTheme
                    .labelMedium
                    ?.copyWith(color: c.faint, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  final Color color;
  const _GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint p = Paint()
      ..color = color
      ..strokeWidth = 1;
    const double step = 28;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), p);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), p);
    }
  }

  @override
  bool shouldRepaint(covariant _GridPainter old) => old.color != color;
}

// ------------------------------------------------------------- curve graph --
class _CurveGraph extends StatelessWidget {
  final AnimationController controller;
  final Curve curve;
  final String label;

  const _CurveGraph({
    required this.controller,
    required this.curve,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return GlassPanel(
      radius: 20,
      padding: const EdgeInsets.fromLTRB(18, 14, 18, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.show_chart_rounded, size: 16, color: c.accent),
              const SizedBox(width: 8),
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: c.text,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 110,
            width: double.infinity,
            child: AnimatedBuilder(
              animation: controller,
              builder: (BuildContext context, Widget? _) {
                return CustomPaint(
                  painter: _CurvePainter(
                    curve: curve,
                    progress: controller.value,
                    line: c.accent,
                    dot: c.accent2,
                    grid: c.border,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _CurvePainter extends CustomPainter {
  final Curve curve;
  final double progress;
  final Color line;
  final Color dot;
  final Color grid;

  _CurvePainter({
    required this.curve,
    required this.progress,
    required this.line,
    required this.dot,
    required this.grid,
  });

  // the plot keeps head-room so overshooting curves stay inside the box
  double _y(double v, double h) => h - (v + 0.25) / 1.5 * h;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint gridPaint = Paint()
      ..color = grid
      ..strokeWidth = 1;
    canvas.drawLine(
      Offset(0, _y(0, size.height)),
      Offset(size.width, _y(0, size.height)),
      gridPaint,
    );
    canvas.drawLine(
      Offset(0, _y(1, size.height)),
      Offset(size.width, _y(1, size.height)),
      gridPaint,
    );

    final Path path = Path();
    const int steps = 90;
    for (int i = 0; i <= steps; i++) {
      final double x = i / steps;
      final double v = curve.transform(x.clamp(0.0, 1.0));
      final Offset o = Offset(x * size.width, _y(v, size.height));
      if (i == 0) {
        path.moveTo(o.dx, o.dy);
      } else {
        path.lineTo(o.dx, o.dy);
      }
    }
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..color = line,
    );

    final double t = progress.clamp(0.0, 1.0);
    final Offset head =
        Offset(t * size.width, _y(curve.transform(t), size.height));
    canvas.drawCircle(head, 9, Paint()..color = dot.withOpacity(0.25));
    canvas.drawCircle(head, 4.5, Paint()..color = dot);
  }

  @override
  bool shouldRepaint(covariant _CurvePainter old) =>
      old.progress != progress || old.curve != curve || old.line != line;
}

// -------------------------------------------------------------- code block --
final RegExp _syntax = RegExp(
  r"(//[^\n]*)|('[^']*')|(\b\d+\.?\d*\b)|\b(const|final|return|true|false|null|var)\b|\b([A-Z][A-Za-z0-9_]*)\b",
);

class _CodeBlock extends StatelessWidget {
  final String code;
  const _CodeBlock({required this.code});

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextStyle base = TextStyle(
      fontFamily: 'JetBrains Mono',
      fontFamilyFallback: const <String>['Courier New', 'monospace'],
      fontSize: 12.5,
      height: 1.55,
      color: c.muted,
    );

    final List<TextSpan> spans = <TextSpan>[];
    int last = 0;
    for (final RegExpMatch m in _syntax.allMatches(code)) {
      if (m.start > last) {
        spans.add(TextSpan(text: code.substring(last, m.start)));
      }
      Color color = c.text;
      if (m.group(1) != null) {
        color = c.faint;
      } else if (m.group(2) != null) {
        color = const Color(0xFF7DD3A0);
      } else if (m.group(3) != null) {
        color = const Color(0xFFF5A97F);
      } else if (m.group(4) != null) {
        color = c.accent2;
      } else {
        color = c.accent;
      }
      spans.add(TextSpan(text: m.group(0), style: TextStyle(color: color)));
      last = m.end;
    }
    if (last < code.length) {
      spans.add(TextSpan(text: code.substring(last)));
    }

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: context.isDark ? const Color(0xFF0B0B16) : const Color(0xFF12121F),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: c.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: c.border)),
            ),
            child: Row(
              children: <Widget>[
                _dot(const Color(0xFFFF5F57)),
                const SizedBox(width: 6),
                _dot(const Color(0xFFFEBC2E)),
                const SizedBox(width: 6),
                _dot(const Color(0xFF28C840)),
                const SizedBox(width: 14),
                Text(
                  'playground.dart',
                  style: TextStyle(
                    fontSize: 11.5,
                    color: Colors.white.withOpacity(0.55),
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18),
            child: SelectableText.rich(
              TextSpan(
                style: base.copyWith(color: Colors.white.withOpacity(0.78)),
                children: spans,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _dot(Color color) => Container(
        width: 10,
        height: 10,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      );
}

// ---------------------------------------------------------------- controls --
class _Controls extends StatelessWidget {
  final double radius;
  final double blur;
  final double hue;
  final double travel;
  final double ms;
  final bool gradient;
  final bool spin;
  final int curve;
  final bool playing;
  final List<String> curveNames;
  final ValueChanged<double> onRadius;
  final ValueChanged<double> onBlur;
  final ValueChanged<double> onHue;
  final ValueChanged<double> onTravel;
  final ValueChanged<double> onMs;
  final ValueChanged<bool> onGradient;
  final ValueChanged<bool> onSpin;
  final ValueChanged<int> onCurve;
  final VoidCallback onPlay;
  final VoidCallback onReset;

  const _Controls({
    required this.radius,
    required this.blur,
    required this.hue,
    required this.travel,
    required this.ms,
    required this.gradient,
    required this.spin,
    required this.curve,
    required this.playing,
    required this.curveNames,
    required this.onRadius,
    required this.onBlur,
    required this.onHue,
    required this.onTravel,
    required this.onMs,
    required this.onGradient,
    required this.onSpin,
    required this.onCurve,
    required this.onPlay,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;

    return GlassPanel(
      radius: 24,
      padding: const EdgeInsets.fromLTRB(24, 22, 24, 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.tune_rounded, size: 18, color: c.accent),
              const SizedBox(width: 10),
              Text('Controls', style: t.titleMedium?.copyWith(color: c.text)),
              const Spacer(),
              _MiniButton(
                icon: playing ? Icons.pause_rounded : Icons.play_arrow_rounded,
                label: playing ? 'Pause' : 'Play',
                onTap: onPlay,
              ),
              const SizedBox(width: 8),
              _MiniButton(
                icon: Icons.restart_alt_rounded,
                label: 'Reset',
                onTap: onReset,
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SliderRow(
            label: 'Corner radius',
            value: radius,
            min: 0,
            max: 54,
            suffix: 'px',
            onChanged: onRadius,
          ),
          _SliderRow(
            label: 'Shadow blur',
            value: blur,
            min: 0,
            max: 80,
            suffix: 'px',
            onChanged: onBlur,
          ),
          _SliderRow(
            label: 'Travel',
            value: travel,
            min: 0,
            max: 150,
            suffix: 'px',
            onChanged: onTravel,
          ),
          _SliderRow(
            label: 'Duration',
            value: ms,
            min: 200,
            max: 2400,
            suffix: 'ms',
            onChanged: onMs,
          ),
          _SliderRow(
            label: 'Hue',
            value: hue,
            min: 0,
            max: 359,
            suffix: 'deg',
            onChanged: onHue,
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Expanded(
                child: _SwitchRow(
                  label: 'Gradient fill',
                  value: gradient,
                  onChanged: onGradient,
                ),
              ),
              Expanded(
                child: _SwitchRow(
                  label: 'Rotate',
                  value: spin,
                  onChanged: onSpin,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'ANIMATION CURVE',
            style: t.labelMedium?.copyWith(color: c.faint, fontSize: 10),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (int i = 0; i < curveNames.length; i++)
                _CurveChip(
                  label: curveNames[i].replaceFirst('Curves.', ''),
                  selected: i == curve,
                  onTap: () => onCurve(i),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SliderRow extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final String suffix;
  final ValueChanged<double> onChanged;

  const _SliderRow({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.suffix,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Expanded(
              child: Text(
                label,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: c.muted),
              ),
            ),
            Text(
              '${value.round()} $suffix',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: c.accent,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 7),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 16),
          ),
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }
}

class _SwitchRow extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  const _SwitchRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return Row(
      children: <Widget>[
        Switch(
          value: value,
          activeColor: c.accent,
          onChanged: onChanged,
        ),
        Flexible(
          child: Text(
            label,
            style:
                Theme.of(context).textTheme.bodySmall?.copyWith(color: c.muted),
          ),
        ),
      ],
    );
  }
}

class _CurveChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _CurveChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(999),
            gradient: selected
                ? LinearGradient(colors: <Color>[c.accent3, c.accent2])
                : null,
            color: selected ? null : c.glass,
            border: Border.all(color: selected ? Colors.transparent : c.border),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: selected ? Colors.white : c.muted,
            ),
          ),
        ),
      ),
    );
  }
}

class _MiniButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  const _MiniButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: c.glass,
            border: Border.all(color: c.border),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 15, color: c.accent),
              const SizedBox(width: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: c.muted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
