import 'dart:io';

import 'package:image_cropper/image_cropper.dart';
import 'package:nylo_framework/nylo_framework.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sailspad/resources/widgets/rounded_button.dart';

class CardImageInput extends StatefulWidget {
  const CardImageInput({
    Key? key,
    this.showSelector = true,
    this.onSelectImage,
    required this.buttonLabel,
    this.profilePhoto = '',
  }) : super(key: key);

  final bool showSelector;
  final Function? onSelectImage;
  final String buttonLabel;
  final String profilePhoto;

  @override
  State<CardImageInput> createState() => _CardImageInputState();
}

class _CardImageInputState extends NyState<CardImageInput> {
  File? imageFile;

  Future<XFile?> _getFromGallery() async {
    return await ImagePicker().pickImage(source: ImageSource.gallery);
  }

  Future<CroppedFile?> cropSelectedImage(String filePath) async {
    return await ImageCropper().cropImage(
      sourcePath: filePath,
      aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
      compressFormat: ImageCompressFormat.png,
      aspectRatioPresets: [CropAspectRatioPreset.square],
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
    return Column(
      children: [
        Container(
          height: 150,
          width: mediaQuery.size.width * 0.35,
          margin: EdgeInsets.only(bottom: 20),
          decoration: BoxDecoration(
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
                    fit: BoxFit.contain,
                  ),
          ),
        ),
        SizedBox(
          width: mediaQuery.size.width * 0.35,
          child: RoundedButton(
            height: 30,
            onPressed: () async {
              await _getFromGallery().then((pickedFile) async {
                if (pickedFile == null) return;
                await cropSelectedImage(pickedFile.path).then((croppedFile) {
                  if (croppedFile == null) return;
                  setState(() {
                    imageFile = File(croppedFile.path);
                  });
                  widget.onSelectImage!(imageFile);
                });
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const FaIcon(
                  FontAwesomeIcons.plus,
                  color: Colors.black,
                  size: 15,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  widget.buttonLabel,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
