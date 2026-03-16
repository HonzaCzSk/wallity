// Automatically picks seo_web.dart on web, seo_stub.dart everywhere else.
export 'seo_stub.dart'
    if (dart.library.html) 'seo_web.dart';
