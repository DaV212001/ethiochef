import 'dart:io';

import 'package:easy_image_viewer/easy_image_viewer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImageField extends StatefulWidget {
  final bool invalid;
  final File? image;
  final Function(File?) onImageSelected;

  const ImageField(
      {Key? key,
      required this.onImageSelected,
      this.image,
      this.invalid = false})
      : super(key: key);

  @override
  State<ImageField> createState() => _ImageFieldState();
}

class _ImageFieldState extends State<ImageField> {
  final picker = ImagePicker();
  File? picture = null;

  @override
  void initState() {
    print(widget.image);
    picture = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              buildImage(context),
              if (picture != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Ink(
                    child: InkWell(
                        onTap: showOptions,
                        child: buildEditIcon(theme.colorScheme.primary)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildImage(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          color: widget.invalid
              ? theme.colorScheme.error
              : theme.colorScheme.primary.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            constraints: BoxConstraints(minHeight: 60, maxHeight: 250.0),
            child: Ink(
              width: double.infinity,
              child: InkWell(
                child: picture != null
                    ? InkWell(
                        onTap: () {
                          final imageProvider = Image.file(picture!).image;
                          showImageViewer(context, imageProvider,
                              backgroundColor: theme.colorScheme.background,
                              swipeDismissible: true,
                              doubleTapZoomable: true,
                              closeButtonColor: theme.colorScheme.primary);
                        },
                        child: Image.file(
                          picture!,
                          fit: BoxFit.cover,
                        ),
                      )
                    : TextButton(
                        onPressed: showOptions,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 30,
                              color:
                                  theme.colorScheme.primary.withOpacity(0.85),
                            ),
                            SizedBox(width: 10),
                            Text("tap_here_to_add_an_image".tr(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: theme.colorScheme.primary
                                      .withOpacity(0.85),
                                ))
                          ],
                        ),
                      ),
              ),
            ),
          )),
    );
  }

  Widget buildEditIcon(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: EdgeInsets.all(8),
        color: color,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        picture = File(pickedFile.path);
        widget.onImageSelected(picture);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        picture = File(pickedFile.path);
        widget.onImageSelected(picture);
      }
    });
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('photo_gallery'.tr()),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('camera'.tr()),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }
}
