import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/screen/carrinho_screen.dart';

class BotaoCarrinho extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(
        Icons.shopping_cart,
        color: Colors.white,
      ),
      onPressed: (){
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => CarrinhoScreen()
        ));
      },
      backgroundColor: Theme.of(context).primaryColor,
    );
  }
}
