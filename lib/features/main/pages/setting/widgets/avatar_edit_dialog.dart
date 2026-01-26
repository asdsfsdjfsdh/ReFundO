import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:refundo/features/main/pages/setting/provider/dio_provider.dart';
import 'package:refundo/features/main/pages/setting/provider/user_provider.dart';
import 'package:refundo/l10n/app_localizations.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

/// 头像编辑对话框
class AvatarEditDialog extends StatefulWidget {
  const AvatarEditDialog({super.key});

  @override
  State<AvatarEditDialog> createState() => _AvatarEditDialogState();
}

class _AvatarEditDialogState extends State<AvatarEditDialog> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // 标题
            Text(
              l10n!.change_avatar,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),

            // 头像预览
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: Colors.grey.shade300, width: 2),
              ),
              child: ClipOval(
                child: _selectedImage != null
                    ? Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                      )
                    : Consumer<UserProvider>(
                        builder: (context, provider, _) {
                          return provider.user?.avatarUrl != null &&
                                  provider.user!.avatarUrl!.isNotEmpty
                              ? Image.network(
                                  provider.user!.avatarUrl!,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return _buildDefaultAvatar(provider);
                                  },
                                )
                              : _buildDefaultAvatar(provider);
                        },
                      ),
              ),
            ),

            const SizedBox(height: 20),

            // 操作按钮
            if (_selectedImage == null) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildActionButton(
                    context,
                    Icons.camera_alt,
                    l10n.take_photo,
                    () => _pickImage(ImageSource.camera),
                  ),
                  _buildActionButton(
                    context,
                    Icons.photo_library,
                    l10n.choose_from_gallery,
                    () => _pickImage(ImageSource.gallery),
                  ),
                ],
              ),
            ] else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(
                    onPressed: () => setState(() => _selectedImage = null),
                    child: Text(l10n.cancel),
                  ),
                  ElevatedButton(
                    onPressed: _isUploading ? null : _uploadAvatar,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue.shade700,
                      foregroundColor: Colors.white,
                    ),
                    child: _isUploading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                Colors.white,
                              ),
                            ),
                          )
                        : Text(l10n.save),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    IconData icon,
    String label,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 28, color: Colors.blue.shade700),
            const SizedBox(height: 8),
            Text(
              label,
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDefaultAvatar(UserProvider provider) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: Text(
          provider.user?.userName.isNotEmpty == true
              ? provider.user!.userName[0].toUpperCase()
              : 'U',
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    // 请求权限
    if (source == ImageSource.camera) {
      final cameraStatus = await Permission.camera.request();
      if (!cameraStatus.isGranted) {
        _showPermissionDeniedDialog();
        return;
      }
    } else {
      final storageStatus = await Permission.photos.request();
      if (!storageStatus.isGranted) {
        _showPermissionDeniedDialog();
        return;
      }
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 85,
      );

      if (image != null) {
        setState(() {
          _selectedImage = File(image.path);
        });
      }
    } catch (e) {
      debugPrint('选择图片失败: $e');
    }
  }

  Future<void> _uploadAvatar() async {
    if (_selectedImage == null) return;

    setState(() => _isUploading = true);

    try {
      final dioProvider = Provider.of<DioProvider>(context, listen: false);
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // 上传图片
      final formData = FormData.fromMap({
        'file': await MultipartFile.fromFile(
          _selectedImage!.path,
          filename: _selectedImage!.path.split('/').last,
        ),
      });

      final response = await dioProvider.dio.post(
        '/api/common/upload',
        data: formData,
      );

      if (response.data['code'] == 1) {
        final String avatarUrl = response.data['data'];

        // 更新用户头像
        await userProvider.updateAvatar(context, avatarUrl);

        if (mounted) {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(AppLocalizations.of(context)!.update_success)),
          );
        }
      }
    } catch (e) {
      debugPrint('上传头像失败: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('上传失败，请重试')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  void _showPermissionDeniedDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n!.notification),
        content: const Text('需要相册或相机权限才能选择图片'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
