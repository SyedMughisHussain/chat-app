import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class ImagePickerWidget extends StatefulWidget {
  const ImagePickerWidget({super.key});

  @override
  State<ImagePickerWidget> createState() => _ImagePickerWidgetState();
}

class _ImagePickerWidgetState extends State<ImagePickerWidget> {
  File? image;

  void _pickedIamge() async {
    final ImagePicker picker = ImagePicker();
    final pickedImage = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      image = File(pickedImage!.path);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        image != null
            ? CircleAvatar(
                backgroundImage: FileImage(image!),
                radius: 50,
              )
            : const CircleAvatar(
                backgroundImage:
                    AssetImage('assets/images/placeholderImage.png'),
                radius: 50,
              ),
        TextButton.icon(
            style: const ButtonStyle(
                foregroundColor: MaterialStatePropertyAll(Colors.pink)),
            onPressed: _pickedIamge,
            icon: const Icon(Icons.image),
            label: const Text('Add image'))
      ],
    );
  }
}
