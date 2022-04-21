import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './playlist_controller.dart';

class PlaylistPage extends GetView<PlaylistController> {
    
    const PlaylistPage({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: const Text('PlaylistPage'),),
            body: Container(),
        );
    }
}