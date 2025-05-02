import 'package:egyptopia/features/Profile/bloc/user_bloc.dart';
import 'package:egyptopia/features/Profile/bloc/user_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:egyptopia/features/auth/data/egyptopia_api_service.dart'; // import service

class ProfileImage extends StatefulWidget {
  final String? imageUrl;
  final ValueChanged<String> onImageChanged;
  final String userId;

  const ProfileImage({
    super.key,
    this.imageUrl,
    required this.onImageChanged,
    required this.userId,
  });

  @override
  State<ProfileImage> createState() => _ProfileImageState();
}

class _ProfileImageState extends State<ProfileImage> {
  final ImagePicker _picker = ImagePicker();
  bool _uploading = false;
  String? _profileUrl;

  @override
  void initState() {
    super.initState();
    _profileUrl = widget.imageUrl;
  }

  Future<void> _pickAndUploadImage() async {
    XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() => _uploading = true);

      try {
        await EgyptopiaApiService().updateUserProfileImage(
          userId: widget.userId,
          image: image,
        );

        setState(() => _uploading = false);

          context.read<UserBloc>().add(LoadUser(widget.userId));

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Profile image updated successfully ✅")),
        );
      } catch (e) {
        setState(() => _uploading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image upload failed ❌\n$e')),
        );
      }
    }
  }

  @override
  void didUpdateWidget(covariant ProfileImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.imageUrl != oldWidget.imageUrl) {
      setState(() => _profileUrl = widget.imageUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _pickAndUploadImage,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: 55,
            backgroundImage: (_profileUrl != null && _profileUrl!.isNotEmpty)
                ? NetworkImage(_profileUrl!)
                : null,
            child: (_profileUrl == null || _profileUrl!.isEmpty)
                ? const Icon(Icons.person, size: 50)
                : null,
          ),
          if (_uploading)
            const Positioned.fill(
              child: ColoredBox(
                  color: Colors.black45,
                  child: Center(child: CircularProgressIndicator())),
            ),
        ],
      ),
    );
  }
}