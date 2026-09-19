import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

/// Filled brand button: gradient fill, hover lift and a soft colour glow.
class BrandButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool dense;

  const BrandButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.dense = false,
  });

  @override
  State<BrandButton> createState() => _BrandButtonState();
}

class _BrandButtonState extends State<BrandButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.dense ? 18 : 26,
            vertical: widget.dense ? 12 : 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(colors: <Color>[c.accent3, c.accent, c.accent2]),
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: c.accent.withOpacity(_hover ? 0.45 : 0.22),
                blurRadius: _hover ? 34 : 18,
                offset: const Offset(0, 10),
                spreadRadius: -6,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.icon != null) ...<Widget>[
                Icon(widget.icon, size: 18, color: Colors.white),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Outlined counterpart: border lights up and fills faintly on hover.
class GhostButton extends StatefulWidget {
  final String label;
  final IconData? icon;
  final VoidCallback onPressed;
  final bool dense;

  const GhostButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.icon,
    this.dense = false,
  });

  @override
  State<GhostButton> createState() => _GhostButtonState();
}

class _GhostButtonState extends State<GhostButton> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          transform: Matrix4.translationValues(0, _hover ? -3 : 0, 0),
          padding: EdgeInsets.symmetric(
            horizontal: widget.dense ? 18 : 26,
            vertical: widget.dense ? 12 : 16,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: _hover ? c.accent.withOpacity(0.10) : Colors.transparent,
            border: Border.all(
              color: _hover ? c.accent : c.border,
              width: 1.2,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              if (widget.icon != null) ...<Widget>[
                Icon(widget.icon, size: 18, color: _hover ? c.accent : c.text),
                const SizedBox(width: 10),
              ],
              Text(
                widget.label,
                style: TextStyle(
                  color: _hover ? c.accent : c.text,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Small circular icon button used for socials / theme toggle.
class IconPill extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onPressed;
  final double size;

  const IconPill({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip = '',
    this.size = 44,
  });

  @override
  State<IconPill> createState() => _IconPillState();
}

class _IconPillState extends State<IconPill> {
  bool _hover = false;

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final Widget pill = MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onPressed,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _hover ? c.accent.withOpacity(0.14) : c.glass,
            border: Border.all(color: _hover ? c.accent : c.border),
          ),
          child: Icon(
            widget.icon,
            size: widget.size * 0.44,
            color: _hover ? c.accent : c.muted,
          ),
        ),
      ),
    );
    return widget.tooltip.isEmpty
        ? pill
        : Tooltip(message: widget.tooltip, child: pill);
  }
}

/// Pill label used for tech tags.
class TagChip extends StatelessWidget {
  final String label;
  final Color? color;
  const TagChip(this.label, {super.key, this.color});

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final Color col = color ?? c.accent;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(999),
        color: col.withOpacity(0.10),
        border: Border.all(color: col.withOpacity(0.35)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          height: 1.1,
          fontWeight: FontWeight.w600,
          color: col,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
