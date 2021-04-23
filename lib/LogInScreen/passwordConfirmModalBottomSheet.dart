import 'package:flutter/material.dart';

class PasswordConfirmPage extends StatelessWidget {
  final String _expectedPassword;
  final void Function() _onPasswordConfirmed;
  final void Function() _onIncorrectPassword;
  final TextEditingController _textEditingController =
      new TextEditingController();
  final _style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);

  PasswordConfirmPage(this._expectedPassword, this._onPasswordConfirmed,
      this._onIncorrectPassword);

  @override
  Widget build(BuildContext context) {
    final title = Text('Please confirm your password below:', style: _style);

    final passwordField = TextField(
      obscureText: true,
      style: _style,
      controller: _textEditingController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password"),
    );

    final confirmButton = Material(
        elevation: 5.0,
        color: Colors.teal,
        child: MaterialButton(
          padding: EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
          child: Text(
            "Confirm",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
          onPressed: () {
            if (_textEditingController.value.text == _expectedPassword) {
              _onPasswordConfirmed();
            } else {
              _onIncorrectPassword();
            }

            Navigator.pop(context);
          },
        ));

    return Container(
        child: Center(
            child: Column(
                children: <Widget>[title, passwordField, confirmButton],
                mainAxisAlignment: MainAxisAlignment.spaceEvenly)));
  }
}
