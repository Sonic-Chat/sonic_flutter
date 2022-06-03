import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ProfilePicture extends StatelessWidget {
  final String imageUrl;
  final double size;

  const ProfilePicture({
    Key? key,
    required this.imageUrl,
    required this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      child: imageUrl.isEmpty
          ? Icon(
              Icons.person,
              size: size / 2,
              color: Colors.white,
            )
          : ClipRRect(
              borderRadius: BorderRadius.circular(100.0),
              child: CachedNetworkImage(
                imageUrl: imageUrl,
                height: size,
                width: size,
                fit: BoxFit.fitWidth,
                progressIndicatorBuilder: (context, url, downloadProgress) {
                  return Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  );
                },
              ),
            ),
      radius: size / 2,
    );
  }
}
