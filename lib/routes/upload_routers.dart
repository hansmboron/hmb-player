import 'package:get/get.dart';
import 'package:hmbplayer/modules/upload/upload_bindings.dart';
import 'package:hmbplayer/modules/upload/upload_page.dart';

class UploadRouters {
  UploadRouters._();
  static final routers = <GetPage>[
    GetPage(
      name: '/upload',
      binding: UploadBindings(),
      page: () => UploadPage(),
    ),
  ];
}
