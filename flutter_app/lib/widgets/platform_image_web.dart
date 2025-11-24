import 'dart:async';
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;
import 'package:flutter/material.dart';

class PlatformImage extends StatefulWidget {
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
  State<PlatformImage> createState() => _PlatformImageState();
}

class _PlatformImageState extends State<PlatformImage> {
  late String _viewType;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _registerViewFactory();
  }

  @override
  void didUpdateWidget(PlatformImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.imageUrl != widget.imageUrl) {
      _registerViewFactory();
    }
  }

  void _registerViewFactory() {
    // Unique key for the view type to avoid collisions
    _viewType = 'img-view-${widget.imageUrl.hashCode}-${DateTime.now().millisecondsSinceEpoch}';

    // Register the view factory
    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) {
      final img = html.ImageElement()
        ..src = widget.imageUrl
        ..style.width = '100%'
        ..style.height = '100%'
        ..style.objectFit = _getObjectFit(widget.fit);

      img.onError.listen((event) {
        if (mounted) {
          setState(() {
            _hasError = true;
          });
        }
      });

      return img;
    });
  }

  String _getObjectFit(BoxFit fit) {
    switch (fit) {
      case BoxFit.contain:
        return 'contain';
      case BoxFit.cover:
        return 'cover';
      case BoxFit.fill:
        return 'fill';
      case BoxFit.fitHeight:
        return 'contain'; // Approximate
      case BoxFit.fitWidth:
        return 'contain'; // Approximate
      case BoxFit.none:
        return 'none';
      case BoxFit.scaleDown:
        return 'scale-down';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      if (widget.errorBuilder != null) {
        return widget.errorBuilder!(context, Exception('Failed to load image'), null);
      }
      return const Center(child: Icon(Icons.broken_image));
    }

    return HtmlElementView(viewType: _viewType);
  }
}
