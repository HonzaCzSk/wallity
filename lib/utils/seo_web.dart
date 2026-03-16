// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class SeoHelper {
  static void set({required String title, required String description}) {
    html.document.title = title;

    final meta = html.document.querySelector('meta[name="description"]');
    if (meta != null) {
      meta.setAttribute('content', description);
    }
  }
}
