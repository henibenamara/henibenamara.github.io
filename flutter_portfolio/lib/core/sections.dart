import 'package:flutter/material.dart';

/// One anchor on the page. The GlobalKey is what the nav scrolls to.
class SectionRef {
  final String label;
  final IconData icon;
  final GlobalKey key;
  SectionRef(this.label, this.icon) : key = GlobalKey();
}

List<SectionRef> buildSections() => <SectionRef>[
      SectionRef('Home', Icons.home_rounded),
      SectionRef('About', Icons.person_outline_rounded),
      SectionRef('Skills', Icons.stacked_bar_chart_rounded),
      SectionRef('Work', Icons.grid_view_rounded),
      SectionRef('Playground', Icons.tune_rounded),
      SectionRef('Journey', Icons.timeline_rounded),
      SectionRef('Contact', Icons.mail_outline_rounded),
    ];
