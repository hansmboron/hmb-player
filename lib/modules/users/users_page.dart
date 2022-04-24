import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:hmbplayer/models/user_model.dart';
import './users_controller.dart';

class UsersPage extends GetView<UsersController> {
  const UsersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Usuários'),
        centerTitle: true,
        actions: [
          const Center(
            child: Text('Total:'),
          ),
          Center(
            child: Obx(
              () => Text(
                controller.len.value.toString(),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                semanticsLabel: "Total de usuários",
              ),
            ),
          ),
          const SizedBox(width: 16),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 0,
          horizontal: _size.width * 0.04,
        ),
        child: FutureBuilder<QuerySnapshot>(
          future: FirebaseFirestore.instance
              .collection('users')
              .get()
              .then((value) {
            controller.len.value = value.size;
            return value;
          }),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(context.theme.primaryColor),
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Erro ao carregar usuários!',
                    style: TextStyle(color: Colors.red, fontSize: 30)),
              );
            } else if (snapshot.data!.size <= 0) {
              return const Center(
                child: Text('Erro ao carregar usuários!',
                    style: TextStyle(color: Colors.red, fontSize: 30)),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.symmetric(vertical: 10),
                physics: const BouncingScrollPhysics(),
                children: snapshot.data!.docs.map((doc) {
                  UserModel user = UserModel.fromDocument(doc);
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user.photoUrl ?? ''),
                    ),
                    title: Text(user.name ?? 'erro'),
                    subtitle: Text(user.email ?? 'erro'),
                  );
                }).toList(),
              );
            }
          },
        ),
      ),
    );
  }
}
