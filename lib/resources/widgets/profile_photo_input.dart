import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ProfilePhotoInput extends StatefulWidget {
  const ProfilePhotoInput({
    Key? key,
    this.showSelector = true,
    this.onSelectImage,
    this.profilePhoto = '',
  }) : super(key: key);

  final bool showSelector;
  final Function? onSelectImage;
  final String profilePhoto;

  @override
  State<ProfilePhotoInput> createState() => _ProfilePhotoInputState();
}

class _ProfilePhotoInputState extends State<ProfilePhotoInput> {
  File? imageFile;
  void _showActionSheet(BuildContext context) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => CupertinoActionSheet(
        title: const Text('Profile Photo'),
        message: const Text('Choose how you\'d like to add your profile photo'),
        actions: <CupertinoActionSheetAction>[
          CupertinoActionSheetAction(
            onPressed: () async {
              await _getFromGallery().then((pickedFile) async {
                if (pickedFile == null) return;
                await cropSelectedImage(pickedFile.path).then((croppedFile) {
                  if (croppedFile == null) return;
                  setState(() {
                    imageFile = File(croppedFile.path);
                  });
                  print(imageFile);
                  Navigator.of(context).pop();
                  widget.onSelectImage!(imageFile);
                });
              });
            },
            child: const Text('Choose from Gallery'),
          ),
          CupertinoActionSheetAction(
            onPressed: () async {
              await _getFromCamera().then((pickedFile) async {
                if (pickedFile == null) return;
                await cropSelectedImage(pickedFile.path).then((croppedFile) {
                  if (croppedFile == null) return;
                  setState(() {
                    imageFile = File(croppedFile.path);
                  });
                  print(imageFile);
                  Navigator.of(context).pop();
                  widget.onSelectImage!(imageFile);
                });
              });
            },
            child: const Text('Open Camera'),
          ),
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          )
        ],
      ),
    );
  }

  Future<XFile?> _getFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<XFile?> _getFromCamera() async {
    return await ImagePicker().pickImage(source: ImageSource.camera);
  }

  Future<CroppedFile?> cropSelectedImage(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Resize the image',
          toolbarColor: Colors.grey,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
        ),
        IOSUiSettings(
          title: 'Resize the image',
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(20),
            image: imageFile != null
                ? DecorationImage(
                    image: FileImage(imageFile!),
                    fit: BoxFit.cover,
                  )
                : DecorationImage(
                    image: widget.profilePhoto != ''
                        ? NetworkImage(widget.profilePhoto) as ImageProvider
                        : const AssetImage(
                            'public/assets/images/placeholder.png',
                          ),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        if (widget.showSelector)
          Positioned(
            bottom: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                _showActionSheet(context);
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  border: Border.all(width: 2, color: Colors.white),
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(50),
                ),
                child: const Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            ),
          )
      ],
    );
  }
}
