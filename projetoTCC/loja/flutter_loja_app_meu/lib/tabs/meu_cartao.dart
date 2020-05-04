import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:flutter_loja_app_meu/pagamento/pagamento_cielo.dart';

import 'package:scoped_model/scoped_model.dart';
String cardNumber = "";
String cardHolderName = "";
String expiryDate = "";
String cvv = "";
bool showBack = false;

FocusNode _focusNode;

final nameController = TextEditingController();
final numeroCartaoController = TextEditingController();
final dataController = TextEditingController();
final CVVController = TextEditingController();
class MeuCartao extends StatefulWidget {

  @override
  _MeuCartaoState createState() => _MeuCartaoState();
}

class _MeuCartaoState extends State<MeuCartao> {

  @override
  void initState() {
    super.initState();
    _focusNode = new FocusNode();
    _focusNode.addListener(() {
      setState(() {
        _focusNode.hasFocus ? showBack = true : showBack = false;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Cartões"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 40,
            ),
            CreditCard(
              cardNumber: cardNumber,
              cardExpiry: expiryDate,
              cardHolderName: cardHolderName,
              cvv: cvv,
              bankName: "Meu cartao",
              showBackSide: showBack,
              frontBackground: CardBackgrounds.black,
              backBackground: CardBackgrounds.white,
              showShadow: true,
            ),
            SizedBox(
              height: 40,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 20,
                  ),
                  child:ScopedModelDescendant<Cielo>(
                    builder: (context, child, model){
                      if(model.isLoading){
                        return Center(child: CircularProgressIndicator(),);
                      }else
                      return Form(
                        child: ListView(
                          padding: EdgeInsets.all(16.0),
                          children: <Widget>[
                        TextFormField(
                        decoration: InputDecoration(
                          hintText: "Nº Cartão",
                        ),
                        keyboardType: TextInputType.number,
                        controller: numeroCartaoController,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                      decoration: InputDecoration(
                      hintText: "Nome"
                      ),
                      controller: nameController,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                      decoration: InputDecoration(
                      hintText: "expiração data MM/AAAA"
                      ),
                      keyboardType: TextInputType.datetime,
                      controller: dataController,
                      ),
                      SizedBox(height: 16.0),
                      TextFormField(
                      decoration: InputDecoration(
                      hintText: "CVV"
                      ),
                      keyboardType: TextInputType.number,
                      controller: CVVController,
                      ),
                      SizedBox(height: 25.0,),
                      SizedBox(height: 44.0,
                      child: RaisedButton(
                      child: Text("Comprar",
                      style: TextStyle(fontSize: 18.0),
                      ),
                      color: Colors.blue,
                      onPressed: () async {
                        model.makePayment();
                      }

                      )
                      )]));
                      },
                  )

                )]
        )

                  ]))
            );
    }
  }

