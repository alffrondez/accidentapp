import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/userData.dart';

class SignUpViewModel {
  String email = "";
  String password = "";
  String contactNumber = "";
  String nickname = "";
  String userType = "";
  String userAvatar = "";
  void SignupUser(Function onError, Function onSuccess) async {
    if (email.isEmpty ||
        password.isEmpty ||
        contactNumber.isEmpty ||
        nickname.isEmpty) {
      onError();
      return;
    }
    try {
      UserCredential userCred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password)
          .catchError(onError);

      FirebaseFirestore.instance
          .collection("users")
          .doc(userCred.user!.uid)
          .set(UserData(
                  userAvatar: userAvatar,
                  accidentsInvolvement: 0,
                  lastknownLocation: null,
                  nickname: nickname,
                  notifications: false,
                  userType: userType,
                  uid: userCred.user!.uid,
                  contactNumber: contactNumber)
              .toMap())
          .catchError(onError);

      onSuccess();
    } catch (e) {}
  }
}
