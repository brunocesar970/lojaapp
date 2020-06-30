import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:awesome_card/awesome_card.dart';
import 'package:flutter_loja_app_meu/Email/email.dart';
import 'package:flutter_loja_app_meu/models/carrinho_model.dart';
import 'package:flutter_loja_app_meu/pagamento/pagamento_cielo.dart';
import 'package:flutter_loja_app_meu/screen/ordem_screen.dart';
import 'package:flutter_loja_app_meu/widget/custom_drawer.dart';
import 'package:fluttertoast/fluttertoast.dart';



class MeuCartao extends StatefulWidget {

  final String orderId;

  final CustomDrawer drawer;



  const MeuCartao({Key key, this.drawer,this.orderId}) : super(key: key);

  @override
  _MeuCartaoState createState() => _MeuCartaoState();

}

class _MeuCartaoState extends State<MeuCartao> {

  String _text = '';
  var email = Email('wallfashion213@gmail.com', 'fashionwall10');


  var ordemGlobal;
  Future _sendEmail() async {
    String pedido = await montarPedido();
    bool result = await email.sendMessage(
       pedido, 'brunocesar970@hotmail.com', 'Compra Efetuaada');
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
                              ordemGlobal = ordem;
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
                              } else {
                                CarrinhoModel.of(context).apagarDocs();
                                setState(() {
                                loading = false;
                              });
                                toast(true);
                                Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            OrdemScreen(ordem)));
                                await _sendEmail();



                               /* var getOrdemDoc = await Firestore.instance
                                    .collection("ordens").where(
                                    "ordemId", isEqualTo: ordem).getDocuments();
                                print("teste Get $getOrdemDoc");
                                await _sendEmail(buildProductsText(
                                    getOrdemDoc.documents[0]));

                                */

                              }

    } catch (e){
                              loading = false;
                            setState(() {

                              });

                              toast(false);

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

  //para cada um dos pedidos
  Future<String> montarPedido() async{

    String texto;
    QuerySnapshot querySnapshot = await Firestore.instance.collection("ordens")
        .where("ordemId",isEqualTo: ordemGlobal).getDocuments();
    for (DocumentSnapshot item in querySnapshot.documents){
        texto = "Descrição: \n ${item["quantity"]} x ${item["product"]["title"]}"+
          "(R\$ ${item["product"]["price"].toStringAsFixed(2)}) \n";

      print(texto);
    }
    return texto;
  }

}