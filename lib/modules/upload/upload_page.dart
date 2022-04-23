import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './upload_controller.dart';

class UploadPage extends GetView<UploadController> {
  const UploadPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UploadPage'),
      ),
      body: Container(),
    );
  }
}
