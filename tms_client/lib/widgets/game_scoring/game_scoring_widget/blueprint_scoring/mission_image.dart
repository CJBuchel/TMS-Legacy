import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:tms/generated/infra/fll_infra/mission.dart';
import 'package:tms/utils/logger.dart';

class MissionImage extends StatefulWidget {
  final Mission mission;
  final String season;
  final double? width;
  final double? height;
  final double? borderRadius;

  const MissionImage({
    super.key,
    required this.mission,
    required this.season,
    this.width,
    this.height,
    this.borderRadius,
  });

  @override
  State<MissionImage> createState() => _MissionImageState();
}

class _MissionImageState extends State<MissionImage> {
  Image _image = const Image(
    image: AssetImage('assets/images/FIRST_LOGO.png'),
    width: 160,
    height: 90,
    fit: BoxFit.fill,
  );

  @override
  void initState() {
    super.initState();

    // default image
    _image = Image(
      image: const AssetImage('assets/images/FIRST_LOGO.png'),
      width: widget.width,
      height: widget.height,
      fit: BoxFit.fill,
    );

    _fetchImage();
  }

  Future<bool> _assetExists(String path) async {
    try {
      await rootBundle.load(path);
      return true;
    } catch (e) {
      TmsLogger().e('Image not found: $path');
      return false;
    }
  }

  void _fetchImage() {
    // fetch image from assets
    // blueprint can override the image (seasons with multiple games share an asset folder)
    final String imagePath = widget.mission.imageUrl ?? 'assets/images/missions/${widget.season}/${widget.mission.id}.png';

    _assetExists(imagePath).then((exists) {
      if (exists && mounted) {
        setState(() {
          _image = Image(
            image: AssetImage(imagePath),
            width: widget.width,
            height: widget.height,
            fit: BoxFit.contain,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius ?? 10),
        child: _image,
      ),
    );
  }
}
