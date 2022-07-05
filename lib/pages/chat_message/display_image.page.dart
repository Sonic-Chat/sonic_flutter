import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:sonic_flutter/arguments/display_image.argument.dart';
import 'package:sonic_flutter/utils/logger.util.dart';

class DisplayImage extends StatelessWidget {
  static const route = "/display-image";

  const DisplayImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DisplayImageArgument displayImageArgument =
        ModalRoute.of(context)!.settings.arguments as DisplayImageArgument;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Image',
        ),
      ),
      body: Center(
        child: CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          imageUrl: displayImageArgument.imageUrl,
          fit: BoxFit.fitWidth,
          progressIndicatorBuilder: (context, url, downloadProgress) {
            return Center(
              child: CircularProgressIndicator(
                value: downloadProgress.progress,
              ),
            );
          },
          errorWidget: (context, url, error) {
            log.e(error);
            return const Icon(Icons.error);
          },
          imageBuilder: (context, imageProvider) => Image(
            image: imageProvider,
            fit: BoxFit.fitWidth,
          ),
        ),
      ),
    );
  }
}
