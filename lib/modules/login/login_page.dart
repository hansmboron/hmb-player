import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    Orientation _orientation = MediaQuery.of(context).orientation;

    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            'assets/images/bg.jpg',
            width: Get.width,
            height: Get.height,
            fit: BoxFit.cover,
          ),
          Container(
            color: Colors.black12,
          ),
          Column(
            children: [
              Visibility(
                visible: _orientation == Orientation.portrait,
                child: Padding(
                  padding: EdgeInsets.only(top: _size.height * 0.18),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: _size.width * 0.4,
                    width: _size.width * 0.4,
                  ),
                ),
                replacement: Padding(
                  padding: EdgeInsets.only(top: _size.height * .08),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 120,
                    width: 120,
                  ),
                ),
              ),
              Stack(
                children: <Widget>[
                  Text(
                    "HMB Player",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      foreground: Paint()
                        ..style = PaintingStyle.stroke
                        ..strokeWidth = 1
                        ..color = Colors.white,
                    ),
                  ),
                  Text(
                    "HMB Player",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                      color: context.theme.primaryColor,
                    ),
                  ),
                ],
              ),
              InkWell(
                onTap: () => controller.login(),
                child: Container(
                  margin: EdgeInsets.only(top: _size.height * .05),
                  clipBehavior: Clip.antiAlias,
                  width: Get.width * 0.9,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                  ),
                  height: 50,
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Entrar com o Google',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: _size.height * .04),
              ElevatedButton.icon(
                onPressed: () {
                  Get.toNamed('/home/local');
                },
                icon: const Icon(Icons.audiotrack_rounded),
                label: const Text('Abrir audios'),
              ),
            ],
          )
        ],
      ),
    );
  }
}
