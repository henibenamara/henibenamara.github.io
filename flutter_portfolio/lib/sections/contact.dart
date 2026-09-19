import 'package:flutter/material.dart';
import '../core/links.dart';
import '../core/responsive.dart';
import '../data/portfolio_data.dart';
import '../theme/app_theme.dart';
import '../widgets/buttons.dart';
import '../widgets/glass.dart';
import '../widgets/reveal.dart';
import '../widgets/section_shell.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _message = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _message.dispose();
    super.dispose();
  }

  void _send() {
    if (!(_form.currentState?.validate() ?? false)) return;
    final String subject =
        Uri.encodeComponent('Portfolio contact from ${_name.text}');
    final String body = Uri.encodeComponent(
      '${_message.text}\n\n--\n${_name.text}\n${_email.text}',
    );
    openLink('mailto:${profile.email}?subject=$subject&body=$body');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        width: 380,
        backgroundColor: context.c.surface,
        content: Text(
          'Opening your mail app with the message ready to send.',
          style: TextStyle(color: context.c.text),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool mobile = context.isMobile;
    final Widget options = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _ContactOption(
          icon: Icons.mail_outline_rounded,
          title: 'Email',
          value: profile.email,
          action: 'Send a message',
          onTap: () => openLink('mailto:${profile.email}'),
          delay: 0,
        ),
        const SizedBox(height: 16),
        _ContactOption(
          icon: Icons.chat_bubble_outline_rounded,
          title: 'WhatsApp',
          value: '+${profile.phone}',
          action: 'Start a chat',
          onTap: () => openLink('https://wa.me/${profile.phone}'),
          delay: 90,
        ),
        const SizedBox(height: 16),
        _ContactOption(
          icon: Icons.business_center_outlined,
          title: 'LinkedIn',
          value: profile.name,
          action: 'Connect',
          onTap: () => openLink(profile.linkedin),
          delay: 180,
        ),
      ],
    );

    final Widget form = Reveal(
      dy: 34,
      child: GlassPanel(
        radius: 24,
        padding: EdgeInsets.all(mobile ? 22 : 30),
        child: Form(
          key: _form,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Tell me about the project',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: context.c.text),
              ),
              const SizedBox(height: 20),
              _Field(
                controller: _name,
                hint: 'Your name',
                icon: Icons.person_outline_rounded,
                validator: (String? v) =>
                    (v == null || v.trim().isEmpty) ? 'Please add your name' : null,
              ),
              const SizedBox(height: 14),
              _Field(
                controller: _email,
                hint: 'Your email',
                icon: Icons.alternate_email_rounded,
                validator: (String? v) {
                  if (v == null || v.trim().isEmpty) return 'Please add your email';
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'That email looks off';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _Field(
                controller: _message,
                hint: 'What are you building?',
                icon: Icons.edit_outlined,
                maxLines: 5,
                validator: (String? v) => (v == null || v.trim().length < 10)
                    ? 'A little more detail helps'
                    : null,
              ),
              const SizedBox(height: 22),
              BrandButton(
                label: 'Send message',
                icon: Icons.send_rounded,
                onPressed: _send,
              ),
            ],
          ),
        ),
      ),
    );

    return SectionShell(
      eyebrow: 'Get in touch',
      title: 'Contact',
      intro:
          'Freelance work, a full-time role or a Flutter question - the form '
          'below opens your mail app with everything filled in.',
      child: mobile
          ? Column(
              children: <Widget>[options, const SizedBox(height: 26), form],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(flex: 4, child: options),
                const SizedBox(width: 26),
                Expanded(flex: 6, child: form),
              ],
            ),
    );
  }
}

class _ContactOption extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String action;
  final VoidCallback onTap;
  final int delay;

  const _ContactOption({
    required this.icon,
    required this.title,
    required this.value,
    required this.action,
    required this.onTap,
    required this.delay,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    final TextTheme t = Theme.of(context).textTheme;
    return Reveal(
      dx: -20,
      delay: Duration(milliseconds: delay),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: GestureDetector(
          onTap: onTap,
          child: GlassPanel(
            radius: 20,
            padding: const EdgeInsets.all(20),
            child: Row(
              children: <Widget>[
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    gradient: LinearGradient(
                      colors: <Color>[
                        c.accent3.withOpacity(0.25),
                        c.accent2.withOpacity(0.25),
                      ],
                    ),
                    border: Border.all(color: c.border),
                  ),
                  child: Icon(icon, size: 20, color: c.accent),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title, style: t.titleMedium?.copyWith(color: c.text)),
                      const SizedBox(height: 2),
                      Text(
                        value,
                        overflow: TextOverflow.ellipsis,
                        style: t.bodySmall?.copyWith(color: c.faint),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        action,
                        style: t.bodySmall?.copyWith(
                          color: c.accent,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.arrow_outward_rounded, size: 18, color: c.faint),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final int maxLines;
  final String? Function(String?) validator;

  const _Field({
    required this.controller,
    required this.hint,
    required this.icon,
    required this.validator,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final AppColors c = context.c;
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: color, width: 1.2),
        );

    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      validator: validator,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: c.text),
      cursorColor: c.accent,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: Theme.of(context)
            .textTheme
            .bodyMedium
            ?.copyWith(color: c.faint),
        prefixIcon: maxLines > 1
            ? null
            : Icon(icon, size: 19, color: c.faint),
        filled: true,
        fillColor: c.glass,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        border: border(c.border),
        enabledBorder: border(c.border),
        focusedBorder: border(c.accent),
        errorBorder: border(const Color(0xFFFF6B6B)),
        focusedErrorBorder: border(const Color(0xFFFF6B6B)),
      ),
    );
  }
}
