import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/models/user_models.dart';
import 'package:flutter_loja_app_meu/screen/cadastro_screen.dart';
import 'package:scoped_model/scoped_model.dart';




class LoginScreen extends StatefulWidget {

  @override
  _State createState() => _State();
}

class _State extends State<LoginScreen> {
  final _senhaController = TextEditingController();
  final _emailController = TextEditingController();
  final _formKey = GlobalKey <FormState>();
  final _scaffodKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffodKey,
        appBar: AppBar(
          title: Text("Entrar"),
          centerTitle: true,
          actions: <Widget>[
            FlatButton(
              child: Text(
                "Criar Conta",
                style: TextStyle(
                  fontSize: 15.0,
                ),
              ),
              textColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute
                  (builder: (context) => CadastroScreen()));
              },
            )
          ],
        ),
        body: ScopedModelDescendant<UserModel>(
          builder: (context, child, model) {
            if (model.isLooding)
              return Center(
                child: CircularProgressIndicator(),
              );
            else
              return Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(16.0),
                  children: <Widget>[
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text) {
                        if (text.isEmpty || !text.contains("@"))
                          return "E-mail inválido!";
                        else
                          return null;
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: _senhaController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty || text.length < 6) {
                          return "Senha deve conter no mínimo 6 caracteres";
                        } else
                          return null;
                      },
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: FlatButton(
                        onPressed: () {
                          if(_emailController.text.isEmpty) {
                            _scaffodKey.currentState.showSnackBar(
                                SnackBar(content: Text(
                                    "Insira seu Email para recuperação"),
                                  backgroundColor: Colors.redAccent,
                                  duration: Duration(seconds: 2),
                                )
                            );
                          }
                          else{
                            model.recuperarSenha(_emailController.text);
                            _scaffodKey.currentState.showSnackBar(
                                SnackBar(content: Text("Confira o seu Email"),
                                  backgroundColor: Theme.of(context).primaryColor,
                                  duration: Duration(seconds: 2),
                                )
                            );
                        }
                          },
                        child: Text("Esqueci mimnha senha",
                          textAlign: TextAlign.right,
                        ),
                        padding: EdgeInsets.zero,
                      ),
                    ),
                    SizedBox(height: 16.0,),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Entrar",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {

                          }
                          model.signIn(email: _emailController.text,
                              pass: _senhaController.text,
                              onSucess: _onSucess,
                              onFailed: _onFailed
                          );
                        },
                      ),
                    )
                  ],
                ),
              );
          },
        )
    );
  }

  void _onSucess() {
    Navigator.of(context).pop();
  }

  void _onFailed() {
    _scaffodKey.currentState.showSnackBar(
        SnackBar(content: Text("Falha ao Entrar, tente novamente!"),
          backgroundColor: Colors.redAccent,
          duration: Duration(seconds: 2),
        )
    );
  }
}

