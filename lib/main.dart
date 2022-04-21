import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hmbplayer/core/ui/theme_extensions.dart';
import 'package:hmbplayer/routes/auth_routers.dart';
import 'package:hmbplayer/routes/home_routers.dart';

import 'core/bindings/application_bindings.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseRemoteConfig.instance.fetchAndActivate();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'HMB Player',
      initialBinding: ApplicationBindings(),
      theme: ThemeData(
        primarySwatch: context.themeOrange,
      ),
      getPages: [
        ...AuthRouters.routers,
        ...HomeRouters.routers,
      ],
      initialRoute: '/login',
    );
  }
}
