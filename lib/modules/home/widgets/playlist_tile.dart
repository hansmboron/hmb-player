import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:hmbplayer/core/ui/theme_extensions.dart';

class PlaylistTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PlaylistTile({
    Key? key,
    required this.snapshot,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      child: ListTile(
        leading: Hero(
          tag: snapshot.id,
          child: CircleAvatar(
            radius: 30,
            backgroundColor: Theme.of(context).canvasColor,
            backgroundImage: CachedNetworkImageProvider(
              snapshot.get('icon'),
            ),
          ),
        ),
        contentPadding: const EdgeInsets.all(8),
        title: Text(
          snapshot.get('title'),
          style: TextStyle(
            color: context.themeOrange,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right_rounded,
          size: 36,
          color: Colors.deepOrange,
        ),
        onTap: () {
          Get.toNamed('/home/playlist', arguments: snapshot);
        },
      ),
    );
  }
}
