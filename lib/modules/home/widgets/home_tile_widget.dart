import 'package:animated_card/animated_card.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';

class PlaylistTile extends StatelessWidget {
  final DocumentSnapshot snapshot;

  const PlaylistTile({
    super.key,
    required this.snapshot,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: AnimatedCard(
        direction: AnimatedCardDirection.right,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          // child: BackdropFilter(
          //   filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.3),
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                width: 1.5,
                color: Colors.white.withOpacity(.3),
              ),
            ),
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
                  color: Colors.grey.shade800,
                  fontWeight: FontWeight.bold,
                  height: 1.1,
                  fontSize: 20,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(snapshot.get('type') == 0 ? 'Músicas' : 'Audiobook'),
              trailing: Icon(
                Icons.keyboard_arrow_right_rounded,
                size: 36,
                color: Colors.grey.shade700,
              ),
              onTap: () {
                Get.toNamed('/home/playlist', arguments: snapshot);
              },
            ),
          ),
        ),
        // ),
      ),
    );
  }
}
