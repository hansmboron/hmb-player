import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'login_controller.dart';

class LoginPage extends GetView<LoginController> {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              Padding(
                padding: EdgeInsets.only(top: Get.height * 0.17),
                child: Image.asset(
                  'assets/images/logo.png',
                  height: Get.width * 0.4,
                  width: Get.width * 0.4,
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
                  margin: const EdgeInsets.only(top: 40),
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
            ],
          )
        ],
      ),
    );
  }
}
