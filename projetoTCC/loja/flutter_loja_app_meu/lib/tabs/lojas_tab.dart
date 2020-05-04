import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/tiles/local_tile.dart';

class LojasTab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //para obter mas de um documento utiliza o query Snapshot
    //o document retorna apenas um documento
    return FutureBuilder<QuerySnapshot>(
      future: Firestore.instance.collection("lojas").getDocuments(),
      builder: (context,snapshot){
        if(!snapshot.hasData)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return ListView(
            children: snapshot.data.documents.map((doc)=> LocalTile(doc)).toList(),
          );
      },
    );
  }
}
