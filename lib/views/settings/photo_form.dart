import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PhotoForm extends StatefulWidget {
  final Function(File?) onImageSelected;
  final String? initialImageUrl;

  const PhotoForm({
    Key? key,
    required this.onImageSelected,
    this.initialImageUrl,
  }) : super(key: key);

  @override
  State<PhotoForm> createState() => _PhotoFormState();
}

class _PhotoFormState extends State<PhotoForm> {
  File? _imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() {
        _imageFile = File(picked.path);
      });
      widget.onImageSelected(_imageFile);
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget avatar;
    if (_imageFile != null) {
      avatar = CircleAvatar(
        radius: 40,
        backgroundImage: FileImage(_imageFile!),
      );
    } else if (widget.initialImageUrl != null &&
        widget.initialImageUrl!.isNotEmpty) {
      avatar = CircleAvatar(
        radius: 40,
        backgroundImage: NetworkImage(widget.initialImageUrl!),
      );
    } else {
      avatar = const CircleAvatar(
        radius: 40,
        child: Icon(Icons.person, size: 40),
      );
    }

    return Column(
      children: [
        avatar,
        const SizedBox(height: 8),
        ElevatedButton.icon(
          onPressed: _pickImage,
          icon: const Icon(Icons.photo),
          label: const Text('Pilih Foto'),
        ),
      ],
    );
  }
}
