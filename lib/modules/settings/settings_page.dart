import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'package:hmbplayer/modules/settings/settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Configurações'),
      ),
      body: const Center(
        child: Text('Configurações'),
      ),
    );
  }
}
