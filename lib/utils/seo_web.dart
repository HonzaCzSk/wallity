import 'package:web/web.dart' as web;

class SeoHelper {
  static void set({required String title, required String description}) {
    web.document.title = title;

    final meta = web.document.querySelector('meta[name="description"]');
    if (meta != null) {
      meta.setAttribute('content', description);
    }
  }
}
