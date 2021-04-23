import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  final String _title;
  ProfilePage(this._title);

  @override
  Widget build(BuildContext context) {
    final avatar = CircleAvatar(backgroundColor: Colors.blue, radius: 50.0);
    final name = Text('$_title', style: TextStyle(fontSize: 18.0));
    const changeAvatarButton = Material(
        elevation: 5.0,
        color: Colors.teal,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Text(
            "Change avatar",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ));

    final nameAndButton = Expanded(child: Column(children: <Widget>[name, SizedBox(height: 10.0,), changeAvatarButton], mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.start) ,flex: 1,);

    final page = Row(children: [avatar, SizedBox(width: 40.0), nameAndButton]);

    return Container(child: Center(child: page), color: Colors.white, padding: EdgeInsets.fromLTRB(20.0, 0.0, 0.0, 30.0));
  }
}
