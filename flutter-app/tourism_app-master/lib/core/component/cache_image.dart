import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CacheImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit? boxFit;
  final bool circle;
  final bool? profileImage;
  final bool previewImage;
  final double? borderRadius;
  final Color? errorColor;
  final Widget Function(BuildContext)? errorWidget;
  final Widget Function(BuildContext)? loadingWidget;
  final BorderRadiusGeometry? customBorderRadius;
  const CacheImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.boxFit,
    this.circle = false,
    this.profileImage = true,
    this.previewImage = true,
    this.borderRadius,
    this.errorColor,
    this.errorWidget,
    this.loadingWidget,
    this.customBorderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: previewImage
          ? () {
              // Add your navigation logic here
              // context.navigateToPage(
              //   PreviewPage(
              //     pictureUrl: imageUrl,
              //   ),
              // );
            }
          : null,
      child: SizedBox(
        width: width,
        height: height,
        child: ClipOval(
          clipBehavior: circle ? Clip.antiAlias : Clip.none,
          child: !imageUrl.contains('.svg')
              ? ClipRRect(
                  borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius ?? 8),
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: width,
                    height: height,
                    fit: boxFit ?? BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: loadingWidget?.call(context) ??
                          SizedBox(
                            height: 30,
                            width: 30,
                            child: CircularProgressIndicator(),
                          ),
                    ),
                    errorWidget: (context, url, error) {
                      if (errorWidget != null) {
                        return errorWidget!(context);
                      }
                      if (errorColor != null) {
                        return Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            borderRadius: customBorderRadius ?? BorderRadius.circular(borderRadius ?? 8),
                            color: errorColor,
                          ),
                        );
                      }
                      return Center(
                        child: profileImage!
                            ? Image.asset(
                                'assets/images/avatar.png', // Update with your asset path
                                width: width,
                                height: height,
                                fit: boxFit ?? BoxFit.cover,
                              )
                            : Image.asset(
                                'assets/images/placeholder.png', // Update with your asset path
                                width: width,
                                height: height,
                                fit: boxFit ?? BoxFit.cover,
                              ),
                      );
                    },
                  ),
                )
              : SvgPictureNetwork(
                  url: imageUrl,
                  width: width ?? 30,
                  height: height ?? 30,
                  fit: boxFit ?? BoxFit.cover,
                  placeholderBuilder: (context) => SizedBox(
                    width: width ?? 30,
                    height: height ?? 30,
                    child: const Icon(
                      Icons.error,
                      color: Colors.grey,
                    ),
                  ),
                  errorBuilder: (context) => SizedBox(
                    width: width ?? 30,
                    height: height ?? 30,
                    child: const Icon(
                      Icons.error,
                      color: Colors.grey,
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}

class SvgPictureNetwork extends StatefulWidget {
  const SvgPictureNetwork({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit,
    this.placeholderBuilder,
    this.errorBuilder,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final Widget Function(BuildContext)? placeholderBuilder;
  final Widget Function(BuildContext)? errorBuilder;

  @override
  State<SvgPictureNetwork> createState() => _SvgPictureNetworkState();
}

class _SvgPictureNetworkState extends State<SvgPictureNetwork> {
  Uint8List? _svgFile;
  var _shouldCallErrorBuilder = false;

  @override
  void initState() {
    super.initState();
    _loadSVG();
  }

  Future<void> _loadSVG() async {
    try {
      final svgLoader = SvgNetworkLoader(widget.url);
      final svg = await svgLoader.prepareMessage(context);

      if (!mounted) return;

      setState(() {
        _shouldCallErrorBuilder = svg == null;
        _svgFile = svg;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _shouldCallErrorBuilder = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_shouldCallErrorBuilder && widget.errorBuilder != null) {
      return widget.errorBuilder!(context);
    }

    if (_svgFile == null) {
      return widget.placeholderBuilder?.call(context) ?? const SizedBox();
    }

    return SvgPicture.memory(
      _svgFile!,
      width: widget.width,
      height: widget.height,
      fit: widget.fit ?? BoxFit.contain,
    );
  }
}
