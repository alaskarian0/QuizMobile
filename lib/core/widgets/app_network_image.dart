import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// A reusable network image widget with a shimmer skeleton loading effect.
///
/// Automatically shows a shimmer placeholder while the image loads,
/// and a fallback icon if the image fails to load.
class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = BorderRadius.zero,
    this.shimmerBaseColor,
    this.shimmerHighlightColor,
    this.errorIcon = Icons.broken_image_outlined,
    this.errorColor,
    this.backgroundColor,
  });

  final String url;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius borderRadius;
  final Color? shimmerBaseColor;
  final Color? shimmerHighlightColor;
  final IconData errorIcon;
  final Color? errorColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        width: width,
        height: height,
        fit: fit,
        // Shimmer skeleton while loading
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return _buildShimmer();
        },
        // Fallback on error
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorFallback();
        },
      ),
    );
  }

  Widget _buildShimmer() {
    return Shimmer.fromColors(
      baseColor: shimmerBaseColor ?? const Color(0xFFE0E0E0),
      highlightColor: shimmerHighlightColor ?? const Color(0xFFF5F5F5),
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: borderRadius,
        ),
      ),
    );
  }

  Widget _buildErrorFallback() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor ?? const Color(0xFFF0F0F0),
        borderRadius: borderRadius,
      ),
      child: Icon(
        errorIcon,
        color: errorColor ?? Colors.grey[400],
        size: (height != null && height! < 60) ? 20 : 36,
      ),
    );
  }
}
