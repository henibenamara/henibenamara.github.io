// ============================================================================
//  EDIT ME.  This is the only file you need to touch to make the site yours.
//  Everything on the page reads from the constants below.
//  Placeholders are marked with  <-- EDIT
// ============================================================================

import 'package:flutter/material.dart';

// ---------------------------------------------------------------- profile ---
class Profile {
  final String name;
  final String role;
  final String greeting;
  final String tagline;
  final String location;
  final String availability;
  final String email;
  final String phone; // international format, digits only, for WhatsApp
  final String github;
  final String linkedin;
  final String facebook;
  final String cvUrl;
  final List<String> rotatingRoles;
  final String initials;

  const Profile({
    required this.name,
    required this.role,
    required this.greeting,
    required this.tagline,
    required this.location,
    required this.availability,
    required this.email,
    required this.phone,
    required this.github,
    required this.linkedin,
    required this.facebook,
    required this.cvUrl,
    required this.rotatingRoles,
    required this.initials,
  });
}

const Profile profile = Profile(
  name: 'Heni Ben Amara', // <-- EDIT
  initials: 'HB', // <-- EDIT (shown in the logo + avatar fallback)
  role: 'Flutter Developer',
  greeting: "Hello, I'm",
  tagline:
      'I build production mobile and web apps from a single Flutter codebase, '
      'with clean architecture, BLoC and Go services behind them.',
  location: 'Sfax, Tunisia (remote)',
  availability: 'Open to freelance & remote work', // <-- EDIT
  email: 'henibenamara10@gmail.com',
  phone: '21623075191',
  github: 'https://github.com/henibenamara', // <-- EDIT (not in the CV)
  linkedin: 'https://www.linkedin.com/in/henibenamara',
  facebook: 'https://www.facebook.com/henibenamara1/',
  // Put your PDF at  web/cv.pdf  and this link just works after a build.
  cvUrl: 'cv.pdf',
  rotatingRoles: <String>[
    'Flutter Developer',
    'Software Engineer',
    'Mobile Engineer',
  ],
);

// --------------------------------------------------------------- about ------
const String aboutParagraph1 =
    'I am a Flutter engineer with 4+ years of hands-on experience building '
    'production mobile and web applications from a single codebase, backed by '
    'Go services. I specialise in clean architecture, BLoC/Cubit state '
    'management and multi-tenant systems.';

const String aboutParagraph2 =
    'I ship enterprise platforms in multinational Agile/Scrum teams, '
    'including a time-tracking app used by 3,000+ employees across 20+ '
    'companies, with trilingual (EN/DE/FR) localization.';

class Highlight {
  final IconData icon;
  final String title;
  final String body;
  const Highlight(this.icon, this.title, this.body);
}

const List<Highlight> highlights = <Highlight>[
  Highlight(Icons.account_tree_rounded, 'Clean architecture',
      'BLoC/Cubit, Freezed and dependency injection in a Dart monorepo'),
  Highlight(Icons.apartment_rounded, 'Multi-tenant',
      'Role-based access, SSO and cross-tenant admin tooling'),
  Highlight(Icons.devices_rounded, 'One codebase',
      'Mobile and Web from the same Dart source'),
];

class StatItem {
  final String label;
  final double value;
  final String suffix;
  const StatItem(this.label, this.value, this.suffix);
}

const List<StatItem> stats = <StatItem>[
  StatItem('Years with Flutter', 4, '+'),
  StatItem('Employees on my time-tracking app', 3000, '+'),
  StatItem('Companies served', 20, '+'),
  StatItem('Third-party packages on this site', 0, ''),
];

// --------------------------------------------------------------- skills -----
class Skill {
  final String name;
  final double level; // 0.0 .. 1.0
  const Skill(this.name, this.level);
}

class SkillGroup {
  final String title;
  final IconData icon;
  final List<Skill> skills;
  const SkillGroup(this.title, this.icon, this.skills);
}

const List<SkillGroup> skillGroups = <SkillGroup>[
  // Skill names come from the CV; the bar levels are not in it. <-- EDIT
  SkillGroup('Flutter & Dart', Icons.flutter_dash, <Skill>[
    Skill('Flutter (mobile + web)', 0.95),
    Skill('Dart', 0.92),
    Skill('Kotlin', 0.55),
    Skill('React.js / Angular / Node.js', 0.65),
  ]),
  SkillGroup('State & architecture', Icons.account_tree_rounded, <Skill>[
    Skill('BLoC / Cubit', 0.92),
    Skill('GetX', 0.75),
    Skill('Clean architecture & SOLID', 0.88),
    Skill('GoRouter, Freezed, Melos monorepo', 0.85),
  ]),
  SkillGroup('Backend, auth & tooling', Icons.cloud_queue_rounded, <Skill>[
    Skill('Go, PocketBase, REST APIs', 0.78),
    Skill('Keycloak / OAuth2 / OIDC', 0.80),
    Skill('SQL, MongoDB, .NET', 0.70),
    Skill('GitLab CI/CD, Git, Jira', 0.82),
  ]),
];

// -------------------------------------------------------------- projects ----
enum MockStyle { tracker, chat, dashboard, shop }

class Project {
  final String title;
  final String subtitle;
  final String description;
  final List<String> tags;
  final String codeUrl;
  final String liveUrl;
  final List<Color> gradient;
  final MockStyle mock;
  final String? image; // e.g. 'assets/images/project1.png' (optional)

  const Project({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tags,
    required this.gradient,
    required this.mock,
    this.codeUrl = '',
    this.liveUrl = '',
    this.image,
  });
}

const List<Project> projects = <Project>[
  // Card artwork is painted at runtime; swap in real screenshots via
  // Project.image and add codeUrl / liveUrl where you can share them. <-- EDIT
  Project(
    title: 'Time-tracking platform',
    subtitle: 'Flutter web + mobile for 20+ companies',
    description:
        'Time-tracking app used by 3,000+ employees across 20+ companies, '
        'with EN/DE/FR localization and Keycloak SSO.',
    tags: <String>['Flutter', 'BLoC', 'Keycloak', 'Go'],
    gradient: <Color>[Color(0xFF4DB5FF), Color(0xFF8B5CF6)],
    mock: MockStyle.tracker,
  ),
  Project(
    title: 'Resource booking',
    subtitle: 'Multi-tenant desk & room reservations',
    description:
        'Interactive floor-plan editor with drag-and-drop positioning, '
        'real-time availability and role-based access for employees, admins '
        'and super admins.',
    tags: <String>['Flutter', 'PocketBase', 'Multi-tenant', 'RBAC'],
    gradient: <Color>[Color(0xFF22D3EE), Color(0xFF3B82F6)],
    mock: MockStyle.dashboard,
  ),
  Project(
    title: 'Enterprise suite',
    subtitle: 'Finance, HRM & CRM for 200+ employees',
    description:
        'Full-scale enterprise app with advanced dashboards and a '
        'barcode/QR scanner module for inventory capture and ERP integration.',
    tags: <String>['Flutter', 'GetX', 'ERP', 'GitLab CI'],
    gradient: <Color>[Color(0xFFF59E0B), Color(0xFFEF4444)],
    mock: MockStyle.chat,
  ),
  Project(
    title: 'Delivery platform',
    subtitle: 'Route and order tracking for local businesses',
    description:
        'End-of-study project shipped in 5 months across Flutter, ReactJS, '
        'Node.js and MongoDB. Recognised as "Best Project" of the cohort.',
    tags: <String>['Flutter', 'ReactJS', 'Node.js', 'MongoDB'],
    gradient: <Color>[Color(0xFF34D399), Color(0xFF0EA5E9)],
    mock: MockStyle.shop,
  ),
];

// ------------------------------------------------------------ experience ----
class TimelineEntry {
  final String period;
  final String role;
  final String org;
  final String body;
  final List<String> tags;
  const TimelineEntry({
    required this.period,
    required this.role,
    required this.org,
    required this.body,
    this.tags = const <String>[],
  });
}

const List<TimelineEntry> timeline = <TimelineEntry>[
  TimelineEntry(
    period: 'Feb 2024 - Present',
    role: 'Flutter Developer',
    org: 'PASS Consulting Group - Germany, remote',
    body:
        'Time-tracking and multi-tenant booking platforms, a super admin '
        'panel, Keycloak auth and a clean-architecture Dart monorepo '
        '(3 apps + shared packages) with GitLab CI/CD.',
    tags: <String>['Flutter', 'BLoC', 'Go', 'Keycloak'],
  ),
  TimelineEntry(
    period: 'May 2023 - Jan 2024',
    role: 'Flutter Developer',
    org: 'Unilog - Sfax, Tunisia',
    body:
        'Enterprise app covering Finance, HRM, CRM and dashboards for 200+ '
        'employees, plus a barcode/QR scanner module for ERP inventory.',
    tags: <String>['Flutter', 'GetX', 'GitLab CI'],
  ),
  TimelineEntry(
    period: 'Nov 2022 - May 2023',
    role: 'Software Developer',
    org: 'Logicom Informatique Sfax',
    body:
        'ERP modules (Inventory, Production, Commercial) in VB.NET, Flutter '
        'and ReactJS, plus production bug fixing and stakeholder consulting.',
    tags: <String>['Flutter', 'ReactJS', 'VB.NET'],
  ),
  TimelineEntry(
    period: 'Feb 2022 - Jun 2022',
    role: 'End-of-Study Internship',
    org: 'Procan - Sfax, Tunisia',
    body:
        'Delivery platform on Flutter, ReactJS, Node.js and MongoDB, shipped '
        'in 5 months and recognised as "Best Project" of the cohort.',
    tags: <String>['Flutter', 'Node.js', 'MongoDB'],
  ),
];
