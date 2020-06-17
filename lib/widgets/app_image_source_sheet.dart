import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AppimageSourceSheet extends StatelessWidget {
  final picker = ImagePicker();
  final Function(File) onImageSelected;

  AppimageSourceSheet(this.onImageSelected);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: BottomSheet(
        builder: (BuildContext context) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                leading: Icon(
                  Icons.photo_camera,
//                    color: Theme.of(context).accentColor,
                ),
                title: Text('Tirar foto'),
                onTap: () async {
                  var pickedFile =
                      await picker.getImage(source: ImageSource.camera);
                  if (pickedFile != null)
                    onImageSelected(File(pickedFile.path));
                  else
                    onImageSelected(null);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.image,
//                    color: Theme.of(context).accentColor,
                ),
                title: Text('Escolher existente...'),
                onTap: () async {
                  var pickedFile =
                      await picker.getImage(source: ImageSource.gallery);
                  if (pickedFile != null)
                    onImageSelected(File(pickedFile.path));
                  else
                    onImageSelected(null);
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
        onClosing: () {},
      ),
    );
  }
}
