import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/datas/produto_carrinho.dart';
import 'package:flutter_loja_app_meu/models/user_models.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoModel extends Model {
  UserModel user;
  List<CarrinhoProduto> products = [];
  CarrinhoModel(this.user) {
    if (user.isLoggedIn()) _loadCartItem();
  }

  String cupomCode;
  int descontoPorcentagem = 0;
  bool isLoading = false;

  static CarrinhoModel of(BuildContext context) =>
      ScopedModel.of<CarrinhoModel>(context);

  void addCarrinhoitem(CarrinhoProduto carrinhoProduto) {
    products.add(carrinhoProduto);

    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .add(carrinhoProduto.toMap())
        .then((doc) {
      carrinhoProduto.cid = doc.documentID;
    });
    notifyListeners();
  }

  void removerCarrinhoItem(CarrinhoProduto carrinhoProduto) {
    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(carrinhoProduto.cid)
        .delete();

    products.remove(carrinhoProduto);
    notifyListeners();
  }

  void decProduct(CarrinhoProduto carrinhoProduto) {
    carrinhoProduto.quantity--;
    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(carrinhoProduto.cid)
        .updateData(carrinhoProduto.toMap());
    notifyListeners();
  }

  void incProduct(CarrinhoProduto carrinhoProduto) {
    carrinhoProduto.quantity++;
    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(carrinhoProduto.cid)
        .updateData(carrinhoProduto.toMap());
    notifyListeners();
  }

  void setCupom(String cupomCode, int descontoPorcentagem) {
    this.cupomCode = cupomCode;
    this.descontoPorcentagem = descontoPorcentagem;
  }

  void _loadCartItem() async {
    QuerySnapshot query = await Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .getDocuments();

    products = query.documents
        .map((doc) => CarrinhoProduto.fromDocument(doc))
        .toList();
    notifyListeners();
  }

  double getProdutoPreco() {
    double price = 0.0;
    for (CarrinhoProduto c in products) {
      if (c.productData != null) price += c.quantity * c.productData.price;
    }
    return price;
  }

  double getDesconto() {
    return getProdutoPreco() * descontoPorcentagem / 100;
  }

  double fretePreco() {
    return 0.10;
  }

  void updatePreco() {
    notifyListeners();
  }

  double precoTotal() {
    return getProdutoPreco() + fretePreco() - getDesconto();
  }

  int pegarOrdemID(CarrinhoProduto carrinhoProduto) {
    Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .document(carrinhoProduto.cid)
        .get();
  }

  Future<String> finalizarPedido() async {
    if (products.length == 0) return null;

    isLoading = true;
    notifyListeners();

    double produtosPreco = getProdutoPreco();
    double getfretePreco = fretePreco();
    double desconto = getDesconto();


    await Firestore.instance
        .collection("status")
        .document("pedidos")
        .setData({"quantidadePedidos": FieldValue.increment(1)}, merge: true);
    DocumentSnapshot pedidosSnapshot =
    await Firestore.instance.collection("status").document("pedidos").get();
    int ordemID = pedidosSnapshot.data["quantidadePedidos"] ;
    DocumentReference refOrdem =
        await Firestore.instance.collection("ordens").add({
      "ordemId": ordemID,
      "clienteId": user.firebaseUser.uid,
      "products":
          products.map((carrinhoProduto) => carrinhoProduto.toMap()).toList(),
      "fretePreco": getfretePreco,
      "produtoPreco": produtosPreco,
      "desconto": desconto,
      "precoTotal": produtosPreco - desconto + getfretePreco,
      "status": 1
    });

    await Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("ordem")
        .document(refOrdem.documentID)
        .setData({"ordemId": refOrdem});
        isLoading = false;
        notifyListeners();
// Como dividir para nn perder os dados e só apagar se caso o pagamento for aprovado do carrinho.
    return ordemID.toString();
  }

  void apagarDocs () async{
    QuerySnapshot query = await Firestore.instance
        .collection("user")
        .document(user.firebaseUser.uid)
        .collection("carrinho")
        .getDocuments();

    for (DocumentSnapshot doc in query.documents) {
      doc.reference.delete();
    }
    products.clear();
    cupomCode = null;
    descontoPorcentagem = 0;
    isLoading = false;
    notifyListeners();

  }
}
