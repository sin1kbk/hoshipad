export 'platform_image_stub.dart'
    if (dart.library.html) 'platform_image_web.dart'
    if (dart.library.io) 'platform_image_io.dart';
