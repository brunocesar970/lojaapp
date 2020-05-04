import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/datas/product_data.dart';
import 'package:flutter_loja_app_meu/datas/produto_carrinho.dart';
import 'package:flutter_loja_app_meu/models/carrinho_model.dart';

class CartTile extends StatelessWidget {
  final CarrinhoProduto carrinhoProduto;

  CartTile(this.carrinhoProduto);

  @override
  Widget build(BuildContext context) {

    Widget _buildContext(){
      CarrinhoModel.of(context).updatePreco();
      return Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(8.0),
            width: 120.0,
            child: Image.network(carrinhoProduto.productData.imagens[0],
            fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Container(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    carrinhoProduto.productData.title,
                    style: TextStyle(fontWeight: FontWeight.w500,fontSize: 17.0),
                  ),
                  Text(
                    "Tamanho: ${carrinhoProduto.size}",
                    style: TextStyle(fontWeight: FontWeight.w300),
                  ),
                  Text(
                    "R\$ ${carrinhoProduto.productData.price.toStringAsFixed(2)}",
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    //espaçamento igual da linha
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(Icons.remove),
                        color: Theme.of(context).primaryColor,
                        onPressed: carrinhoProduto.quantity > 1 ?
                            (){
                          CarrinhoModel.of(context).decProduct(carrinhoProduto);
                            } : null,
                      ),
                      Text(carrinhoProduto.quantity.toString()),

                      IconButton(
                        icon: Icon(Icons.add),
                        color: Theme.of(context).primaryColor,
                        onPressed: (){
                          CarrinhoModel.of(context).incProduct(carrinhoProduto);
                        },),
                      FlatButton(
                        child: Text("Remover"),
                        textColor: Colors.grey[500],
                        onPressed:(){
                          CarrinhoModel.of(context).removerCarrinhoItem(carrinhoProduto);
                        } ,
                      )

                    ],
                  )
                ],
              ),
            ),
          )
        ],
      );
    }



    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child: carrinhoProduto.productData == null ?
      FutureBuilder<DocumentSnapshot>(
        future: Firestore.instance.collection("produtos").document(carrinhoProduto.category)
        .collection("itens").document(carrinhoProduto.pid).get(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            carrinhoProduto.productData = ProductData.fromDocument(snapshot.data);
            return _buildContext();
          }else{
            return Container(
              height: 70.0,
              child: CircularProgressIndicator(),
              alignment: Alignment.center,
            );
          }
        },

      ) :
          _buildContext()
      ,
    );
  }
}
