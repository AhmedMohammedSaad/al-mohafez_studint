import 'dart:io';

import 'package:almohafez/almohafez/core/services/navigation_service/global_navigation_service.dart';
import 'package:almohafez/almohafez/core/utils/app_strings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:photo_view/photo_view.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';

import 'app_custom_image_view.dart';

class AppCustomUserAvatar extends StatefulWidget {
  const AppCustomUserAvatar({
    super.key,
    required this.radius,
    required this.image,
    required this.userId,
    this.showEdit = true,
    this.avatarBackColor,
    this.onImageUpdated,
  });
  final double radius;
  final String image;
  final bool showEdit;
  final Color? avatarBackColor;
  final String userId;
  final Function(String)? onImageUpdated;

  @override
  State<AppCustomUserAvatar> createState() => _AppCustomUserAvatarState();
}

class _AppCustomUserAvatarState extends State<AppCustomUserAvatar> {
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;

  Future<void> _pickAndPreviewImage() async {
    try {
      final XFile? pickedFile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 80,
      );

      if (pickedFile != null) {
        final File selectedImage = File(pickedFile.path);
        _navigateToFullScreenPreview(selectedImage);
      }
    } catch (error) {
      debugPrint('Error picking image: $error');
    }
  }

  void _navigateToFullScreenPreview(File image) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenImagePreview(
          imageFile: image,
          onEditComplete: _onImageEditComplete,
        ),
      ),
    );
  }

  void _onImageEditComplete(File selectedImage) {
    setState(() {
      _selectedImage = selectedImage;
    });
    widget.onImageUpdated?.call(selectedImage.path);
    NavigationService.goBack();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2.2,
      height: widget.radius * 2.2,
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [_buildAvatar(), if (widget.showEdit) _buildEditIcon()],
      ),
    );
  }

  Widget _buildAvatar() {
    return _selectedImage?.path != null || widget.image.isNotEmpty
        ? AppCustomImageView(
            imagePath: _selectedImage?.path ?? widget.image,
            height: widget.radius * 2,
            width: widget.radius * 2,
            radius: BorderRadius.circular(widget.radius),
            fit: BoxFit.cover,
          )
        : CircleAvatar(
            radius: widget.radius,
            backgroundColor: widget.avatarBackColor ?? Colors.white24,
            child: const Icon(Icons.person, color: Colors.white),
          );
  }

  Widget _buildEditIcon() {
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        onPressed: _pickAndPreviewImage,
        icon: const CircleAvatar(
          radius: 15.0,
          child: Icon(Icons.camera_alt, size: 18.0),
        ),
        tooltip: AppStrings.editImage,
      ),
    );
  }
}

class FullScreenImagePreview extends StatefulWidget {
  const FullScreenImagePreview({
    super.key,
    required this.imageFile,
    required this.onEditComplete,
  });
  final File imageFile;
  final Function(File) onEditComplete;

  @override
  State<FullScreenImagePreview> createState() => _FullScreenImagePreviewState();
}

class _FullScreenImagePreviewState extends State<FullScreenImagePreview> {
  late File _currentImage;
  final PhotoViewController _controller = PhotoViewController();
  final bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _currentImage = widget.imageFile;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.blackConstant,
      body: Stack(
        children: [
          Column(children: [_buildHeader(context), _buildImagePreview()]),
          if (_isLoading) _buildLoadingOverlay(),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.7),
      padding: const EdgeInsets.only(top: 40, left: 16, right: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => finish(context),
            tooltip: AppStrings.back,
          ),
          TextButton(
            onPressed: () => widget.onEditComplete(_currentImage),
            child: Text(
              AppStrings.save,
              style: TextStyle(color: AppColors.success),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildImagePreview() {
    return Expanded(
      child: PhotoView(
        controller: _controller,
        filterQuality: FilterQuality.high,
        enableRotation: true,
        enablePanAlways: true,
        imageProvider: FileImage(_currentImage),
        backgroundDecoration: const BoxDecoration(color: Colors.black),
        loadingBuilder: (context, progress) => Center(
          child: CircularProgressIndicator(
            value: progress == null
                ? null
                : progress.cumulativeBytesLoaded /
                      (progress.expectedTotalBytes ?? 1),
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingOverlay() {
    return Container(
      color: Colors.black.withValues(alpha: 0.8),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 4.0,
          color: Colors.white,
          semanticsLabel: AppStrings.loading,
        ),
      ),
    );
  }
}
