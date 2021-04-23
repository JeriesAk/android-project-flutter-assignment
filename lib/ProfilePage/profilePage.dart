import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/Authentication/UserState.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePage extends StatelessWidget {
  final String _title;
  final ImageProvider<Object> _image;
  ProfilePage(this._title, this._image);

  @override
  Widget build(BuildContext context) {
    final avatar = _image != null
        ? CircleAvatar(
            backgroundImage: this._image, radius: 50.0)
        : CircleAvatar(backgroundColor: Colors.blue, radius: 50.0);
    final name = Text('$_title', style: TextStyle(fontSize: 18.0));
    final changeAvatarButton = Material(
        elevation: 5.0,
        color: Colors.teal,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Text(
            "Change avatar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () async {
            final imagePicker = ImagePicker();
            final filePickerResult =
                await imagePicker.getImage(source: ImageSource.gallery);
            if (filePickerResult == null) {
              final snackBar = SnackBar(
                  content: Text('No image selected.',
                      style: TextStyle(fontSize: 18),
                      textAlign: TextAlign.center));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
              return;
            }

            final userState = Provider.of<UserState>(context, listen: false);
            print(filePickerResult.path);

            await userState.updateProfilePic(File(filePickerResult.path));
          },
        ));

    final nameAndButton = Expanded(
      child: Column(
          children: <Widget>[
            name,
            SizedBox(
              height: 10.0,
            ),
            changeAvatarButton
          ],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start),
      flex: 1,
    );

    final page = Row(children: [avatar, SizedBox(width: 40.0), nameAndButton]);

    return Container(
        child: Center(child: page),
        color: Colors.white,
        padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 30.0));
  }
}
