import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'dart:async';

class UserModel extends Model{
  //usuário Atual

FirebaseAuth auth = FirebaseAuth.instance;
//usuario do momento
FirebaseUser firebaseUser;
//todos os dados do usuario principais
Map<String,dynamic> userData = Map();

  bool isLooding = false;

  static UserModel of(BuildContext context) =>
      ScopedModel.of<UserModel>(context);

  

  @override
  void addListener(VoidCallback listener) {
    super.addListener(listener);
     _loadCurrentUser();
  }

  void signUp({@required Map<String,dynamic> userData,@required String pass,
    @required VoidCallback onSucess,
    @required VoidCallback onFailed}){
    isLooding = true;
    notifyListeners();

    auth.createUserWithEmailAndPassword(email: userData['email'],
        password: pass).then((user) async {
      firebaseUser = user;

      await savedUserDaata(userData);

      onSucess();
      isLooding = false;
      notifyListeners();
    }).catchError((e){
      onFailed();
      isLooding=false;
      notifyListeners();
      print(e);
    });

  }

  void signIn({@required String email,@required String pass,
    @required VoidCallback onSucess,
    @required VoidCallback onFailed }) async{
    isLooding =true;
    notifyListeners();
    auth.signInWithEmailAndPassword(email: email, password: pass).then(
        (user) async{
        firebaseUser = user;
        await _loadCurrentUser();

        onSucess();
        isLooding = false;
        notifyListeners();
        }).catchError((e){
          onFailed();
          isLooding = false;
          notifyListeners();

    }
    );
}

void recuperarSenha(String email){
auth.sendPasswordResetEmail(email: email);
}

bool isLoggedIn(){
  return firebaseUser != null;
}

void signOut() async {
   await auth.signOut();
    userData = Map();
    firebaseUser = null;
    notifyListeners();
}



Future<Null> savedUserDaata(Map<String, dynamic> userData)async{

    this.userData = userData;
  await  Firestore.instance.collection("user").document(firebaseUser.uid).setData(userData);
}

Future<Null>_loadCurrentUser()async{
    if(firebaseUser == null)
      firebaseUser = await auth.currentUser();
    if(firebaseUser != null){
      if(userData["name"]== null){
        DocumentSnapshot docUser = 
        await Firestore.instance.collection("user").document(firebaseUser.uid).get();
        userData = docUser.data;
      }
    }
    notifyListeners();
}

}