import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:flutter_loja_app_meu/models/carrinho_model.dart';
import 'package:flutter_loja_app_meu/pagamento/pagamento_cielo.dart';
import 'package:flutter_loja_app_meu/screen/ordem_screen.dart';
import 'package:flutter_loja_app_meu/widget/custom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'email.dart';


class MeuCartao extends StatefulWidget {



  final CustomDrawer drawer;



  const MeuCartao({Key key, this.drawer}) : super(key: key);

  @override
  _MeuCartaoState createState() => _MeuCartaoState();

}

class _MeuCartaoState extends State<MeuCartao> {

  String _text = '';
  var email = Email('bruno.cesarti10@gmail.com', '96475302');

  void _sendEmail() async {
    bool result = await email.sendMessage(
        'Pedido realizado', 'brunocesar970@hotmail.com', 'Compra Efetuaada');
    print(_text);

    setState(() {
      _text = result ? 'Enviado.' : 'Não enviado.';
    });
  }



  final TextEditingController nameController = TextEditingController();
  final TextEditingController numeroCartaoController = TextEditingController();
  final TextEditingController dataController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();

  String cardNumber = "";
  String cardHolderName = "";
  String expiryDate = "";
  String cvv = "";
  bool showBack = false;
  FocusNode _focusNode;
  bool loading =false;

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
      drawer: widget.drawer,
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
                  child: Form(
                    child: Column(
                      children: <Widget>[
                        TextFormField(
                          decoration: InputDecoration(
                            hintText: "Nº Cartão",
                          ),
                          keyboardType: TextInputType.number,
                          controller: numeroCartaoController,
                          maxLength: 16,
                          onChanged: (value) {
                            setState(() {
                              cardNumber = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: "Nome"),
                          controller: nameController,
                          onChanged: (value) {
                            setState(() {
                              cardHolderName = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(
                              hintText: "expiração data MM/AAAA"),
                          keyboardType: TextInputType.datetime,
                          controller: dataController,
                          maxLength: 7,
                          onChanged: (value) {
                            setState(() {
                              expiryDate = value;
                            });
                          },
                        ),
                        SizedBox(height: 16.0),
                        TextFormField(
                          decoration: InputDecoration(hintText: "CVV"),
                          keyboardType: TextInputType.number,
                          controller: cvvController,
                          onChanged: (value) {
                            setState(() {
                              cvv = value;
                            });
                          },
                          focusNode: _focusNode,
                          maxLength: 3,
                        ),
                        SizedBox(height: 25.0),
                        SizedBox(
                          height: 44.0,
                          width: 500.0,
                          child: RaisedButton(

                             child: loading ? CircularProgressIndicator(backgroundColor: Colors.white,) : Text(
                          "Comprar",
                              style: TextStyle(fontSize: 18.0),
                            ),
                            color: Colors.blue,
                            onPressed: () async {
                            try{
                              setState(() {
                                loading = true;
                              });
                              String ordem = await  CarrinhoModel.of(context).finalizarPedido();
                              String payment = await Cielo.makePayment(
                                  cardNumber: numeroCartaoController.text,
                                  nameController: nameController.text,
                                  dataController: dataController.text,
                                  cvvController: cvvController.text,
                                  valor: CarrinhoModel.of(context).precoTotal(),
                                  ordem: ordem
                              );
                              if (payment == null){
                                throw Error();
                              }
                              toast(true);
                              setState(() {
                                loading = false;
                              });
                              Navigator.of(context).pushReplacement(MaterialPageRoute(
                                  builder: (context)=> OrdemScreen(ordem)));
                              _sendEmail();

    } catch (e){
                              loading = false;
                              toast(false);
                              setState(() {

                              });

                            }

                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  toast(bool success) => Fluttertoast.showToast(
      msg: success ? "Pagamento aprovado com sucesso!" :"Pagamento negado",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.TOP,
      timeInSecForIosWeb: 2,
      backgroundColor: success ? Colors.green : Colors.red,
      textColor: Colors.white,
      fontSize: 16.0
  );

}