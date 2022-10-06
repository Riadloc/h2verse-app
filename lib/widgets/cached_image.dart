import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CachedImage extends StatelessWidget {
  const CachedImage(this.url, {Key? key, this.width, this.height, this.fit})
      : super(key: key);

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;

  @override
  Widget build(BuildContext context) {
    if (url == '') return Container();
    final Widget Function(BuildContext, ImageProvider<Object>)? imageBuilder =
        (width != null || height != null || fit != null)
            ? (context, imageProvider) => Container(
                width: width,
                height: height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: fit,
                  ),
                ))
            : null;
    return CachedNetworkImage(
      imageUrl: url,
      imageBuilder: imageBuilder,
      progressIndicatorBuilder: (context, url, downloadProgress) => Container(
        color: Colors.black26,
        width: width,
        height: height,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
    );
  }
}
