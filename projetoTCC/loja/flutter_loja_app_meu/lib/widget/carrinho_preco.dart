import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/models/carrinho_model.dart';
import 'package:scoped_model/scoped_model.dart';

class CarrinhoPreco extends StatelessWidget {

 //receber função pelo construtor
  final  VoidCallback compra;
  CarrinhoPreco(this.compra);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 8.0,vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: ScopedModelDescendant<CarrinhoModel>(
          builder: (context,child,model){

            double price = model.getProdutoPreco();
            double  desconto = model.getDesconto();
            double frete = model.fretePreco();

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Resumo do Pedido",
                  textAlign: TextAlign.start,
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
                SizedBox(height: 12.0,),
                Row(
                  //fic
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Subtotal"),
                    Text("R\$ ${price.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Desconto"),
                    Text("R\$ - ${desconto.toStringAsFixed(2)}")
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Entrega"),
                    Text("R\$ ${frete.toStringAsFixed(2)}"),
                  ],
                ),
                Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                  Text("Total",
                  style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                    Text("R\$ ${(price + frete - desconto).toStringAsFixed(2)}",
                      style: TextStyle(color: Theme.of(context).primaryColor,
                      fontSize: 16.0
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 12.0,),
                RaisedButton(
                  child: Text("Continuar"),
                  textColor: Colors.white,
                  color: Theme.of(context).primaryColor,
                  onPressed: compra,
                )

              ],
            );
          },
        ),
      ),
    );
  }
}
