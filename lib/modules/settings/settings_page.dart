import 'package:flutter/material.dart';
import 'package:get/state_manager.dart';
import 'settings_controller.dart';

class SettingsPage extends GetView<SettingsController> {
  const SettingsPage({super.key});

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
