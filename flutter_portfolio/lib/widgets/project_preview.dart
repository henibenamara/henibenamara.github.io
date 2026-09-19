import 'package:flutter/material.dart';
import '../data/portfolio_data.dart';

/// Every project thumbnail is drawn at runtime with CustomPainter - no image
/// assets, no mockup files. Swap in a real screenshot by setting
/// `image:` on the project in portfolio_data.dart.
class ProjectPreview extends StatelessWidget {
  final Project project;
  final double height;

  const ProjectPreview({super.key, required this.project, this.height = 230});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: project.gradient,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // soft light blobs on top of the gradient
          Positioned(
            left: -40,
            top: -30,
            child: _Blob(color: Colors.white.withOpacity(0.18), size: 160),
          ),
          Positioned(
            right: -30,
            bottom: -50,
            child: _Blob(color: Colors.black.withOpacity(0.22), size: 190),
          ),
          if (project.image != null)
            Image.asset(project.image!, fit: BoxFit.cover)
          else
            Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 26),
                child: Transform.rotate(
                  angle: -0.05,
                  child: _Phone(style: project.mock, accent: project.gradient.last),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  final Color color;
  final double size;
  const _Blob({required this.color, required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: <Color>[color, color.withOpacity(0)],
        ),
      ),
    );
  }
}

class _Phone extends StatelessWidget {
  final MockStyle style;
  final Color accent;
  const _Phone({required this.style, required this.accent});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 168,
      height: 230,
      child: CustomPaint(painter: _PhonePainter(style: style, accent: accent)),
    );
  }
}

class _PhonePainter extends CustomPainter {
  final MockStyle style;
  final Color accent;
  _PhonePainter({required this.style, required this.accent});

  @override
  void paint(Canvas canvas, Size size) {
    final RRect body = RRect.fromRectAndRadius(
      Offset.zero & size,
      const Radius.circular(26),
    );

    // device shadow + body
    canvas.drawRRect(
      body.shift(const Offset(0, 10)),
      Paint()
        ..color = Colors.black.withOpacity(0.25)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 16),
    );
    canvas.drawRRect(body, Paint()..color = const Color(0xFF0B0B14));
    canvas.drawRRect(
      body,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = Colors.white.withOpacity(0.18),
    );

    canvas.save();
    canvas.clipRRect(body);

    // status bar + notch
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(size.width / 2 - 22, 8, 44, 7),
        const Radius.circular(4),
      ),
      Paint()..color = Colors.white.withOpacity(0.12),
    );

    const double pad = 14;
    final double w = size.width - pad * 2;
    double y = 28;

    void bar(double x, double top, double width, double height, double opacity,
        {Color? color, double radius = 4}) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(x, top, width, height),
          Radius.circular(radius),
        ),
        Paint()..color = (color ?? Colors.white).withOpacity(opacity),
      );
    }

    switch (style) {
      case MockStyle.tracker:
        bar(pad, y, w * 0.55, 9, 0.75);
        bar(pad, y + 16, w * 0.35, 6, 0.3);
        y += 38;
        for (int i = 0; i < 3; i++) {
          bar(pad + i * (w / 3 + 2), y, w / 3 - 4, 34, 0.10);
          bar(pad + i * (w / 3 + 2) + 8, y + 10, w / 6, 5, 0.45,
              color: accent, radius: 3);
        }
        y += 46;
        // area chart
        final Path line = Path();
        final Path area = Path();
        final List<double> pts = <double>[0.5, 0.35, 0.62, 0.28, 0.48, 0.18, 0.4];
        for (int i = 0; i < pts.length; i++) {
          final double x = pad + w * (i / (pts.length - 1));
          final double py = y + 56 * pts[i];
          if (i == 0) {
            line.moveTo(x, py);
            area.moveTo(x, y + 56);
            area.lineTo(x, py);
          } else {
            line.lineTo(x, py);
            area.lineTo(x, py);
          }
        }
        area.lineTo(pad + w, y + 56);
        area.close();
        canvas.drawPath(
          area,
          Paint()
            ..shader = LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: <Color>[
                Colors.white.withOpacity(0.35),
                Colors.white.withOpacity(0.02),
              ],
            ).createShader(Rect.fromLTWH(pad, y, w, 56)),
        );
        canvas.drawPath(
          line,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.4
            ..strokeCap = StrokeCap.round
            ..color = Colors.white.withOpacity(0.92),
        );
        y += 72;
        for (int i = 0; i < 3; i++) {
          bar(pad, y + i * 20, w, 14, 0.08);
          bar(pad + 6, y + i * 20 + 4, 6, 6, 0.5, color: accent, radius: 3);
          bar(pad + 20, y + i * 20 + 5, w * (0.5 - i * 0.08), 4, 0.35);
        }
        break;

      case MockStyle.chat:
        bar(pad, y, 22, 22, 0.16, radius: 11);
        bar(pad + 30, y + 3, w * 0.4, 7, 0.6);
        bar(pad + 30, y + 14, w * 0.25, 5, 0.25);
        y += 40;
        final List<bool> mine = <bool>[false, true, false, true, true];
        final List<double> widths = <double>[0.62, 0.46, 0.7, 0.36, 0.5];
        for (int i = 0; i < mine.length; i++) {
          final double bw = w * widths[i];
          final double x = mine[i] ? pad + (w - bw) : pad;
          canvas.drawRRect(
            RRect.fromRectAndCorners(
              Rect.fromLTWH(x, y, bw, 24),
              topLeft: const Radius.circular(12),
              topRight: const Radius.circular(12),
              bottomLeft: Radius.circular(mine[i] ? 12 : 3),
              bottomRight: Radius.circular(mine[i] ? 3 : 12),
            ),
            Paint()
              ..color = mine[i]
                  ? Colors.white.withOpacity(0.85)
                  : Colors.white.withOpacity(0.14),
          );
          y += 30;
        }
        bar(pad, size.height - 40, w, 26, 0.12, radius: 13);
        bar(size.width - pad - 26, size.height - 37, 20, 20, 0.85,
            color: accent, radius: 10);
        break;

      case MockStyle.dashboard:
        bar(pad, y, w * 0.45, 9, 0.75);
        y += 24;
        for (int i = 0; i < 2; i++) {
          bar(pad + i * (w / 2 + 3), y, w / 2 - 3, 40, 0.10);
          bar(pad + i * (w / 2 + 3) + 8, y + 9, w / 5, 6, 0.55,
              color: accent, radius: 3);
          bar(pad + i * (w / 2 + 3) + 8, y + 22, w / 3, 8, 0.4);
        }
        y += 52;
        final double baseY = y + 60;
        final List<double> hs = <double>[0.35, 0.6, 0.45, 0.9, 0.55, 0.75];
        for (int i = 0; i < hs.length; i++) {
          final double bw = (w - 10) / hs.length - 4;
          final double bh = 56 * hs[i];
          bar(pad + i * (bw + 5), baseY - bh, bw, bh, 0.28 + 0.5 * hs[i],
              radius: 3);
        }
        y = baseY + 14;
        canvas.drawArc(
          Rect.fromLTWH(pad, y, 42, 42),
          -1.6,
          4.2,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 7
            ..strokeCap = StrokeCap.round
            ..color = Colors.white.withOpacity(0.9),
        );
        canvas.drawArc(
          Rect.fromLTWH(pad, y, 42, 42),
          2.7,
          2.0,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 7
            ..strokeCap = StrokeCap.round
            ..color = Colors.white.withOpacity(0.25),
        );
        bar(pad + 54, y + 8, w - 60, 6, 0.4);
        bar(pad + 54, y + 22, w - 80, 6, 0.2);
        break;

      case MockStyle.shop:
        bar(pad, y, w * 0.5, 9, 0.75);
        bar(pad, y + 18, w, 20, 0.10, radius: 10);
        y += 48;
        for (int r = 0; r < 2; r++) {
          for (int col = 0; col < 2; col++) {
            final double cw = w / 2 - 5;
            final double x = pad + col * (cw + 10);
            final double top = y + r * 74;
            bar(x, top, cw, 46, 0.16, radius: 8);
            bar(x, top + 52, cw * 0.7, 6, 0.45);
            bar(x, top + 62, cw * 0.4, 5, 0.25, color: accent);
          }
        }
        bar(pad, size.height - 40, w, 28, 0.12, radius: 14);
        for (int i = 0; i < 4; i++) {
          bar(pad + 14 + i * (w - 34) / 3, size.height - 31, 10, 10,
              i == 0 ? 0.9 : 0.3,
              color: i == 0 ? accent : Colors.white, radius: 5);
        }
        break;
    }

    // screen sheen
    canvas.drawRect(
      Offset.zero & size,
      Paint()
        ..shader = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: <Color>[
            Colors.white.withOpacity(0.06),
            Colors.white.withOpacity(0.0),
          ],
        ).createShader(Offset.zero & size),
    );
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PhonePainter old) =>
      old.style != style || old.accent != accent;
}
