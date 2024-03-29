import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/models/user_models.dart';
import 'package:flutter_loja_app_meu/screen/login_screen.dart';
import 'package:flutter_loja_app_meu/tiles/ordem_tile.dart';

class OrdemTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if(UserModel.of(context).isLoggedIn()){

      String uid = UserModel.of(context).firebaseUser.uid;

      return FutureBuilder<QuerySnapshot>(
        future: Firestore.instance.collection("user").document(uid)
        .collection("ordem").getDocuments(),
        builder: (context, snapshot){
          if(! snapshot.hasData)
            return Center(
              child: CircularProgressIndicator(),
            );
          else{
            return ListView(
              children: snapshot.data.documents.map((doc) => OrdemTile(doc.documentID)).toList()
              .reversed.toList(),
            );
          }
        },
      );







    }else{


      return Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.list,
              size: 80.0,color: Theme.of(context).primaryColor,
            ),
            SizedBox(height: 16.0,),
            Text("Faça o login para acompanhar!",
              style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.0,),
            RaisedButton(
              child: Text("Entrar",
                style: TextStyle(fontSize: 18.0),
              ),
              textColor: Colors.white,
              color: Theme.of(context).primaryColor,
              onPressed: (){
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context)=>LoginScreen()
                ));
              },
            )
          ],
        ),
      );



    }
  }
}
