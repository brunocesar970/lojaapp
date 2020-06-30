import 'package:flutter/material.dart';
import 'package:flutter_loja_app_meu/screen/home_screen.dart';


class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Image.asset('assets/fashion.png',fit: BoxFit.cover,height: 500,),
              SizedBox(height: 20,),
              Center(
                child: CircularProgressIndicator(),
              )
            ],
          )

        ],
      )

    );
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 5)).then((_){
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => HomeScreen())
      );
    });
  }
}
