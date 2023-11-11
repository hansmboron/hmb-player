import 'package:get/get.dart';
import '../modules/upload/upload_bindings.dart';
import '../modules/upload/upload_page.dart';

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
