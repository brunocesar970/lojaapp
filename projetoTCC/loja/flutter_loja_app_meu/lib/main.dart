import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/models/carrinho_model.dart';
import 'package:flutter_loja_app_meu/models/user_models.dart';
import 'package:flutter_loja_app_meu/screen/splash.dart';
import 'package:scoped_model/scoped_model.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScopedModel<UserModel>(
     model: UserModel(),
      child: ScopedModelDescendant <UserModel>(
        builder: (context, child, model){
          return ScopedModel<CarrinhoModel>(
            model: CarrinhoModel(model),
            child: MaterialApp(
              title: 'Loja do Bruno',
              theme: ThemeData(
                  primarySwatch: Colors.blue,
                  primaryColor: Color.fromARGB(255, 4, 125, 141)
              ),
              home: Splash(),
              debugShowCheckedModeBanner: false,
            ),
          );
        },
      )
    );
  }
}