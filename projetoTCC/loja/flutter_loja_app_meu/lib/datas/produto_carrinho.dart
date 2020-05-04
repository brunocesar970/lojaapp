
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_loja_app_meu/datas/product_data.dart';

class CarrinhoProduto {
  //carrinho ID
  String cid;

  String category;
  //produto ID
  String pid;
  String size;
  int quantity;

  ProductData productData;
  CarrinhoProduto();

  CarrinhoProduto.fromDocument(DocumentSnapshot document){
    cid =document.documentID;
    category = document.data["category"];
    pid =document.data["pid"];
    quantity = document.data["quantity"];
    size = document.data["size"];
  }
  Map<String, dynamic> toMap(){
    return{
      "category": category,
      "pid" : pid,
      "quantity": quantity,
      "size":size,
      "product": productData.toResumedMap()
    };
  }


}