import 'package:flutter/foundation.dart';

/// Non-web fallback so the same source still compiles on mobile/desktop.
void openLink(String url) {
  debugPrint('openLink (no-op outside web): $url');
}

void hideSplash() {}
