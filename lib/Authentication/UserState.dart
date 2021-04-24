import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

enum Status { Uninitialized, Authenticated, Authenticating, Unauthenticated }

class UserState with ChangeNotifier {
  FirebaseAuth _auth;
  User _user;
  Status _status = Status.Uninitialized;
  ImageProvider<Object> _profilePicture;

  UserState.instance() : _auth = FirebaseAuth.instance {
    _auth.authStateChanges().listen(_onAuthStateChanged);
  }

  bool isUserLoggedIn() {
    return _status == Status.Authenticated;
  }

  Future<void> registerUser(String email, String password) async {
    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
  }

  Future<bool> signIn(String email, String password) async {
    try {
      _status = Status.Authenticating;
      notifyListeners();
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      return true;
    } catch (e) {
      _status = Status.Unauthenticated;
      notifyListeners();
      return false;
    }
  }

  Future signOut() async {
    _auth.signOut();
    _status = Status.Unauthenticated;
    notifyListeners();
    return Future.delayed(Duration.zero);
  }

  Future<void> _onAuthStateChanged(User firebaseUser) async {
    if (firebaseUser == null) {
      _status = Status.Unauthenticated;
    } else {
      _user = firebaseUser;
      _status = Status.Authenticated;
      _profilePicture = firebaseUser.photoURL != null ? NetworkImage(firebaseUser.photoURL) : null;
    }
    notifyListeners();
  }

  Future<void> updateProfilePic(File imageFile) async {
    _profilePicture = FileImage(File(imageFile.path));
    notifyListeners();
    var firebaseStorageRef =
        FirebaseStorage.instance.ref().child('profilePics/${_user.uid}');
    var uploadTask = firebaseStorageRef.putFile(imageFile);
    var taskSnapshot = await uploadTask;
    await taskSnapshot.ref.getDownloadURL().then(
      (value) async {
        await _user.updateProfile(
            displayName: _user.displayName, photoURL: value);
      },
    );
  }

  String getUserEmail() {
    return _user.email;
  }

  ImageProvider<Object> getUserProfilePictureUrl() => _profilePicture;

  Status getUserStatus() => _status;
}
