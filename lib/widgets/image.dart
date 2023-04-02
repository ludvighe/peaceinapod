import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class PodNetworkImage extends StatelessWidget {
  final String url;
  final double? width;
  final double? height;
  final Widget errorWidget;
  final Duration imageFadeDuration = const Duration(milliseconds: 150);

  const PodNetworkImage({
    super.key,
    required this.url,
    required this.errorWidget,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (kIsWeb) {
      return Image.network(
        url,
        width: width,
        height: height,
        errorBuilder: (context, error, stackTrace) => errorWidget,
      );
    } else {
      return CachedNetworkImage(
        imageUrl: url,
        width: width,
        height: height,
        fadeInDuration: imageFadeDuration,
        errorWidget: (context, url, error) => errorWidget,
      );
    }
  }
}
