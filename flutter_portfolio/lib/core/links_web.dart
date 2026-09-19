import 'dart:js_interop';

@JS('window.open')
external JSAny? _windowOpen(JSString url, JSString target);

@JS('window.removeSplash')
external JSAny? _removeSplash();

/// Opens http(s), mailto: and tel: links in a new tab.
void openLink(String url) {
  if (url.isEmpty) return;
  try {
    _windowOpen(url.toJS, '_blank'.toJS);
  } catch (_) {
    // ignored - popup blocked or API unavailable
  }
}

/// Fades out the HTML splash defined in web/index.html.
void hideSplash() {
  try {
    _removeSplash();
  } catch (_) {
    // splash already gone
  }
}
