import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './users_controller.dart';

class UsersPage extends GetView<UsersController> {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UsersPage'),
      ),
      body: Container(),
    );
  }
}
