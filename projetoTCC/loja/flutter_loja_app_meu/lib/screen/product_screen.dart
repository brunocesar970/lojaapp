import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/datas/product_data.dart';
import 'package:carousel_pro/carousel_pro.dart';
import 'package:flutter_loja_app_meu/datas/produto_carrinho.dart';
import 'package:flutter_loja_app_meu/models/carrinho_model.dart';
import 'package:flutter_loja_app_meu/models/user_models.dart';
import 'package:flutter_loja_app_meu/screen/carrinho_screen.dart';
import 'package:flutter_loja_app_meu/screen/login_screen.dart';
class ProductScreen extends StatefulWidget {

  final ProductData product;


  ProductScreen(this.product);
  @override
  _ProductScreenState createState() => _ProductScreenState(product);
}

class _ProductScreenState extends State<ProductScreen> {

 final ProductData product;
 String size;

 _ProductScreenState(this.product);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(product.title),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          AspectRatio(
            aspectRatio: 0.9,
            child: Carousel(
              images: (product.imagens.map((url){
                return NetworkImage(url);
              }).toList()
            ),dotSize: 4.0,
                dotSpacing: 15.0,
              dotBgColor: Colors.transparent,
              dotColor: Theme.of(context).primaryColor,
              autoplay: false,
              //para as imagens rodarem automaticamente
              /*autoplayDuration: ,*/
          ),
          ),
          Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  product.title,
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500
                  ),
                  maxLines: 3,
                ),
                Text(
                  "R\$ ${product.price.toStringAsFixed(2)}",
                  style: TextStyle(
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor
                  ),
                ),
                //colocar espaçamentos em uma coluna e linha
                SizedBox(height: 16.0,),
                Text(
                  "Tamanho",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                SizedBox(
                  height: 34.0,
                  child: GridView(
                    padding: EdgeInsets.symmetric(vertical: 4.0),
                    scrollDirection: Axis.horizontal,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 0.5,
                    ),
                    children: product.size.map(
                        (s) {
                        return GestureDetector(
                          onTap: (){
                            setState(() {
                              size = s;
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              //arrendondando
                              borderRadius: BorderRadius.all(Radius.circular(4.0)),
                              border: Border.all(
                                color: s == size ? Theme.of(context).primaryColor :
                                  Colors.grey[500],
                                width: 3.0
                              ),
                            ),
                            width: 50.0,
                            alignment: Alignment.center,
                            child: Text(s),
                          ),
                        ) ;
                        }
                    ).toList(),
                  ),
                ),
                SizedBox(height: 16.0,),
                SizedBox(
                  height: 44.0,
                  child: RaisedButton(
                    //quando não passa nenhuma função o botão é desativado
                    onPressed: size!= null ?
                        (){
                        if(UserModel.of(context).isLoggedIn()){

                          CarrinhoProduto carrinhoProduto = CarrinhoProduto();
                           carrinhoProduto.size = size;
                           carrinhoProduto.quantity = 1;
                           carrinhoProduto.pid = product.id;
                           carrinhoProduto.category = product.category;
                           carrinhoProduto.productData = product;
                          //adicionar o carrinho
                          CarrinhoModel.of(context).addCarrinhoitem(carrinhoProduto);

                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context)=>CarrinhoScreen()
                          ));

                        }else{
                          Navigator.of(context).push(MaterialPageRoute(
                            builder: (context)=>LoginScreen()
                          ));
                        }
                        } :null,
                    child: Text(UserModel.of(context).isLoggedIn() ? "Adicionar ao Carrinho" :
                      "Entre para Comprar!",
                    style:TextStyle(fontSize: 18.0) ,),
                    color: Theme.of(context).primaryColor,
                    textColor: Colors.white,
                  ),
                ),
                SizedBox(height: 16.0,),
                Text(
                  "Descrição",
                  style: TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.w500
                  ),
                ),
                Text(
                  product.description,
                  style: TextStyle(
                    fontSize: 16.0
                  ),
                )
              ],
            ),
          )


        ],
      ),
    );
  }
}
