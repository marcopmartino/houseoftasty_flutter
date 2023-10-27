import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/AppColors.dart';
import 'package:houseoftasty/view/widget/CustomDecoration.dart';
import 'package:houseoftasty/network/FirebaseAuthHelper.dart';
import 'package:houseoftasty/utility/Validator.dart';

import 'HomePage.dart';
import 'LoginPage.dart';
import 'package:houseoftasty/network/ProfileNetwork.dart';

class SignUpPage extends StatefulWidget {
  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _nomeTextController = TextEditingController();
  final _cognomeTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwTextController = TextEditingController();
  final _chkPasswTextController = TextEditingController();

  bool _isProcessing = false;

  final _focusUser = FocusNode();
  final _focusNome = FocusNode();
  final _focusCognome = FocusNode();
  final _focusEmail = FocusNode();
  final _focusPassword = FocusNode();
  final _focusChkPsw = FocusNode();

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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('Registrati')),
      body: SingleChildScrollView(
        child: Container(
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
                            controller: _usernameTextController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                CustomDecoration.loginInputDecoration('Username'),
                          )), //Username
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 15, bottom: 15),
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
                              left: 25.0, right: 25.0, top: 15, bottom: 15),
                          child: TextFormField(
                            controller: _nomeTextController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                CustomDecoration.loginInputDecoration('Nome'),
                          )), //Nome
                      Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 15, bottom: 15),
                          child: TextFormField(
                            controller: _cognomeTextController,
                            style: TextStyle(color: Colors.white),
                            decoration:
                                CustomDecoration.loginInputDecoration('Cognome'),
                          )), //Cognome
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 15, bottom: 15),
                        child: TextFormField(
                          controller: _passwTextController,
                          validator: (value) =>
                              Validator.validatePassword(password: value),
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration:
                              CustomDecoration.loginInputDecoration('Password'),
                        ),
                      ), //Password
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 15, bottom: 40),
                        child: TextFormField(
                          controller: _chkPasswTextController,
                          validator: (value) =>
                              Validator.validateEqualPassword(password: _passwTextController.text, chkPassword: value),
                          style: TextStyle(color: Colors.white),
                          obscureText: true,
                          decoration: CustomDecoration.loginInputDecoration(
                              'Conferma password'),
                        ),
                      ), //ChkPassword
                    ],
                  )), //Signup Form
              _isProcessing
                  ? CircularProgressIndicator()
                  : Column(
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
                              _focusUser.unfocus();
                              _focusNome.unfocus();
                              _focusCognome.unfocus();
                              _focusEmail.unfocus();
                              _focusPassword.unfocus();
                              _focusChkPsw.unfocus();

                              if (_formKey.currentState!.validate()) {
                                setState(() {
                                  _isProcessing = true;
                                });

                                Object? user = await FirebaseAuthHelper
                                    .signUpUsingEmailPassword(
                                  email: _emailTextController.text,
                                  password: _passwTextController.text,
                                );

                                if (user != null && user is User) {
                                  Object? result = await ProfileNetwork.addUser(
                                      nome: _nomeTextController.text,
                                      cognome: _cognomeTextController.text,
                                      email: _emailTextController.text,
                                      username: _usernameTextController.text);

                                  if(result == null){
                                    if(context.mounted) {
                                      Navigator.push(context,
                                          MaterialPageRoute(builder: (_) => HomePage(isLogged: true)));
                                    }
                                  }else{
                                    _showAlertDialog(result as String);
                                  }
                                } else {
                                  _showAlertDialog(user as String);
                                }

                                setState(() {
                                  _isProcessing = false;
                                });
                              }
                            },
                            child: Text(
                              'REGISTRATI',
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ), //Bottone 'Registrati'
                        Container(
                            alignment: AlignmentDirectional.bottomCenter,
                            child: TextButton(
                                onPressed: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => LoginPage(),
                                    ),
                                  );
                                },
                                child: Text(
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: Colors.white),
                                    'Hai già un account? Accedi'))), //Text 'Accedi'
                      ],
                    ) //Bottone 'Registrati'
            ],
          ),
        ),
      ),
    );
  }
}
