import 'package:flutter/material.dart';
import 'package:flutter_app/Authentication/UserState.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final description = Text(
        'Welcome to Startup Names Generator. Please log in below.',
        style: _style);

    final emailField = TextField(
        obscureText: false,
        style: _style,
        controller: _emailTextController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
            hintText: "Email"));

    final passwordField = TextField(
      obscureText: true,
      style: _style,
      controller: _passwordTextController,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Password"),
    );

    final userStatus = Provider.of<UserStatus>(context);

    final buttonIsDisabled = userStatus.status == Status.Authenticating;

    final loginButtonOnPressFunction = buttonIsDisabled
        ? null
        : () async {
            final isEmailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(_emailTextController.value.text);
            if (!isEmailValid) {
              final invalidEmailSnackBar = SnackBar(
                  content: Text(
                'Invalid email address.',
                textAlign: TextAlign.center,
                style: _style,
              ));
              ScaffoldMessenger.of(context).showSnackBar(invalidEmailSnackBar);
              return;
            }

            final isPasswordFieldEmpty =
                _passwordTextController.value.text.length == 0;
            if (isPasswordFieldEmpty) {
              final emptyPasswordSnackBar = SnackBar(
                  content: Text('Password must not be empty.',
                      textAlign: TextAlign.center, style: _style));
              ScaffoldMessenger.of(context).showSnackBar(emptyPasswordSnackBar);
              return;
            }
            final isAuthenticationSuccessful = await userStatus.signIn(
                _emailTextController.value.text,
                _passwordTextController.value.text);
            if (isAuthenticationSuccessful == false) {
              final snackBar = SnackBar(
                  content: Text('There was an error logging into the app.',
                      textAlign: TextAlign.center, style: _style));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            } else {
              Navigator.of(context).pop();
            }
          };

    final buttonColor =
        buttonIsDisabled ? Colors.red.withOpacity(0.4) : Colors.red;

    final loginButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: buttonColor,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: loginButtonOnPressFunction,
        child: Text("Login",
            textAlign: TextAlign.center,
            style: _style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );

    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 20.0,
                ),
                description,
                SizedBox(height: 30.0),
                emailField,
                SizedBox(height: 25.0),
                passwordField,
                SizedBox(
                  height: 35.0,
                ),
                loginButton,
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
