import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/models/user_models.dart';
import 'package:scoped_model/scoped_model.dart';



class CadastroScreen extends StatefulWidget {
  @override
  _CadastroScreenState createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey <FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passController = TextEditingController();
  final _enderecoController = TextEditingController();
  final _scaffodKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffodKey,
        appBar: AppBar(
          title: Text("Criar Conta"),
          centerTitle: true,

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
                      controller: _nameController,
                      decoration: InputDecoration(
                          hintText: "Nome Completo"
                      ),
                      validator: (text) {
                        if (text.isEmpty) return "Nome inválido!";
                        else return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                          hintText: "E-mail"
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (text)  {
                        if (text.isEmpty || !text.contains("@"))
                          return "E-mail inválido!";
                        else return null;
                      },
                    ),
                    SizedBox(height: 16.0,),
                    TextFormField(
                      controller: _passController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Senha"
                      ),
                      obscureText: true,
                      validator: (text) {
                        if (text.isEmpty || text.length < 6) {
                          return "Senha deve conter no mínimo 6 caracteres";
                        }
                        else return null;
                      },
                    ),
                    TextFormField(
                      controller: _enderecoController,
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                          hintText: "Endereço"
                      ),
                      validator: (text) {
                        if (text.isEmpty) {
                          return "Endereço inválido";
                        }
                        else return null;
                      },
                    ),
                    SizedBox(height: 16.0,),
                    SizedBox(
                      height: 44.0,
                      child: RaisedButton(
                        child: Text("Criar Conta",
                          style: TextStyle(fontSize: 18.0),
                        ),
                        textColor: Colors.white,
                        color: Theme
                            .of(context)
                            .primaryColor,
                        onPressed: () {
                          if (_formKey.currentState.validate()) {
                            Map <String, dynamic> userData = {
                              "name": _nameController.text,
                              "email": _emailController.text,
                              "endereço": _enderecoController.text,
                            };

                            model.signUp(
                                userData: userData,
                                pass: _passController.text,
                                onSucess: _onSucess,
                                onFailed: _onFailed);
                          }
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

    void _onSucess(){
    _scaffodKey.currentState.showSnackBar(
     SnackBar(content: Text("Usuário criado com sucesso!"),
     backgroundColor: Theme.of(context).primaryColor,
       duration: Duration(seconds: 2),
     )
    );
    Future.delayed(Duration(seconds: 2)).then((_){
    Navigator.of(context).pop();
    });
    }

    void _onFailed(){
      _scaffodKey.currentState.showSnackBar(
          SnackBar(content: Text("Falha na criação do Usuário!"),
            backgroundColor: Colors.redAccent,
            duration: Duration(seconds: 2),
          )
      );
    }

}









