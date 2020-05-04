import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/datas/produto_carrinho.dart';
import 'package:flutter_loja_app_meu/models/carrinho_model.dart';

class DescontoCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0,
      vertical: 4.0),
     //para expandir os descontos
      child: ExpansionTile(
        title: Text(
          "Cumpom Desconto",
          textAlign: TextAlign.start,
          style: TextStyle(
            fontWeight: FontWeight.w500,
            color: Colors.grey[700]
          ),
        ),
        //icone no começo
        leading: Icon(Icons.card_giftcard),
        // icone lado direito
        trailing: Icon(Icons.add),
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: "Digite seu cupom"
              ),
              initialValue: CarrinhoModel.of(context).cupomCode ?? "",
              onFieldSubmitted: (text){
                Firestore.instance.collection("cupons").document(text)
                    .get().then(
                        (docSnap){
                   if(docSnap.data != null){
                     CarrinhoModel.of(context).setCupom(text, docSnap.data["percentual"]);
                     Scaffold.of(context).showSnackBar(
                       SnackBar(content: Text("Desconto de ${docSnap.data["percentual"]}% aplicado"),
                       backgroundColor: Theme.of(context).primaryColor,
                       )
                     );
                   }else{
                     CarrinhoModel.of(context).setCupom(null, 0);
                     Scaffold.of(context).showSnackBar(
                       SnackBar(content: Text("Cupom não existente!"),
                       backgroundColor: Colors.redAccent,
                       )
                     );

                   }
                });
              },

            ),
          )
        ],
      ),
    );
  }
}
