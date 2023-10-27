import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/view/page/SignupPage.dart';
import 'package:houseoftasty/utility/AppColors.dart';
import 'package:houseoftasty/Network/FirebaseAuthHelper.dart';
import 'package:houseoftasty/view/widget/CustomDecoration.dart';
import 'package:houseoftasty/utility/Validator.dart';
import 'package:houseoftasty/view/page/HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwTextController = TextEditingController();

  bool _isProcessing = false;

  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();

  Future<void> _showAlertDialog(String error) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Errore'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(error),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Ottiene dimensioni schermo
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Login')),
      body: SingleChildScrollView(
        child: Container(
          height: size.height - 80,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.sandBrown,
                AppColors.caramelBrown,
              ],
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Center(
                  child: Image.asset('assets/images/logo_medium.png', scale: 1.2),
                ),
              ), //Image
              Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 60, bottom: 15),
                        child: TextFormField(
                          controller: _emailTextController,
                          validator: (value) =>
                              Validator.validateEmail(email: value),
                          style: TextStyle(color: Colors.white),
                          decoration: CustomDecoration.loginInputDecoration('Email'),
                        ),
                      ), //Email
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 15, bottom: 40),
                        child: TextFormField(
                          controller: _passwTextController,
                          validator: (value) =>
                              Validator.validatePassword(password: value),
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: CustomDecoration.loginInputDecoration('Password')
                        ),
                      ),
                    ],
                  )), //Email&Password
              _isProcessing
                  ? CircularProgressIndicator() :
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    height: 50,
                    width: 180,
                    decoration: BoxDecoration(
                        color: AppColors.tawnyBrown,
                        borderRadius: BorderRadius.circular(30)),
                    child: TextButton(
                      onPressed: () async {
                        _focusEmail.unfocus();
                        _focusPassword.unfocus();

                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            _isProcessing = true;
                          });

                          Object? user =
                              await FirebaseAuthHelper.signInUsingEmailPassword(
                            email: _emailTextController.text,
                            password: _passwTextController.text,
                          );


                          setState(() {
                            _isProcessing = false;
                          });

                          print(user);
                          if (user != null && user is User) {
                            if(context.mounted) {
                              Navigator.pushAndRemoveUntil(context,
                                MaterialPageRoute(
                                    builder: (_) => HomePage(isLogged: true)
                                ),
                                (Route route) => false);
                            }
                          }else{
                            _showAlertDialog(user as String);
                          }
                        }
                      },
                      child: Text(
                        'ACCEDI',
                        style: TextStyle(color: Colors.white, fontSize: 20),
                      ),
                    ),
                  ), //Bottone 'Accedi'
                  Container(
                      alignment: AlignmentDirectional.bottomCenter,
                      child: TextButton(
                          onPressed: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (context) => SignUpPage(),
                              ),
                            );
                          },
                          child: Text(
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white),
                              'Non hai un account? Registrati'))),
                ],
              ) //Bottone 'Registrati'
            ],
          ),
        ),
      ),
    );
  }
}
