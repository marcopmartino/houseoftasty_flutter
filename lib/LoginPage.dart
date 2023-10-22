import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/SignupPage.dart';
import 'package:houseoftasty/utility/AppColors.dart';
import 'package:houseoftasty/Network/FirebaseAuthHelper.dart';
import 'package:houseoftasty/utility/Validator.dart';

import 'HomePage.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
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
                  child: Image.asset('assets/medium_logo.png', scale: 1.2),
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
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: 'Email'),
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
                          decoration: InputDecoration(
                              hintStyle: TextStyle(color: Colors.white),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: Colors.white,
                                ),
                              ),
                              labelStyle: TextStyle(color: Colors.white),
                              hintText: 'Password'),
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
                              Navigator.push(context,
                                MaterialPageRoute(builder: (_) => HomePage(isLogged: true)));
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
