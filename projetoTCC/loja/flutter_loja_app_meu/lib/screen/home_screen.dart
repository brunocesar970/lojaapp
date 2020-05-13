import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/tabs/home_tab.dart';
import 'package:flutter_loja_app_meu/tabs/lojas_tab.dart';
import 'package:flutter_loja_app_meu/tabs/meu_cartao.dart';
import 'package:flutter_loja_app_meu/tabs/ordem_tab.dart';
import 'package:flutter_loja_app_meu/tabs/products_tab.dart';
import 'package:flutter_loja_app_meu/widget/botao_carrinho.dart';
import 'package:flutter_loja_app_meu/widget/custom_drawer.dart';


class HomeScreen extends StatelessWidget {
  final _pageController = PageController();
  @override
  Widget build(BuildContext context) {
      return PageView(
          controller: _pageController,
          physics: NeverScrollableScrollPhysics(),
          children: <Widget>[
           Scaffold(
             body: HomeTab(),
             floatingActionButton: BotaoCarrinho(),
             drawer: CustomDrawer(_pageController),
           ),
            Scaffold(
              body: MeuCartao(drawer: CustomDrawer(_pageController)),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Produtos"),
                centerTitle: true,
              ),
              drawer: CustomDrawer(_pageController),
              body: ProductsTab(),
              floatingActionButton: BotaoCarrinho(),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Lojas"),
                centerTitle: true,
              ),
              body: LojasTab(),
              drawer: CustomDrawer(_pageController),
            ),
            Scaffold(
              appBar: AppBar(
                title: Text("Meus Pedidos"),
                centerTitle: true,
              ),
              body: OrdemTab(),
              drawer: CustomDrawer(_pageController),
            )
          ],
        );
    }
  }

