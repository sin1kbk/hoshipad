import 'package:flutter/material.dart';

class PlatformImage extends StatelessWidget {
  final String imageUrl;
  final BoxFit fit;
  final Widget Function(BuildContext, Widget, ImageChunkEvent?)? loadingBuilder;
  final Widget Function(BuildContext, Object, StackTrace?)? errorBuilder;

  const PlatformImage({
    super.key,
    required this.imageUrl,
    this.fit = BoxFit.cover,
    this.loadingBuilder,
    this.errorBuilder,
  });

  @override
  Widget build(BuildContext context) {
    throw UnimplementedError('PlatformImage is not implemented for this platform.');
  }
}
