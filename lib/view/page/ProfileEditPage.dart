
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/ProfileNetwork.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/widget/CustomButtons.dart';
import 'package:houseoftasty/view/widget/TextWidgets.dart';
import 'package:intl/intl.dart';

import '../../Model/Product.dart';
import '../../model/Profile.dart';
import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/Navigation.dart';
import '../../utility/Validator.dart';

import '../../network/ProductNetwork.dart';

import '../widget/CustomDecoration.dart';
import '../widget/CustomScaffold.dart';
import '../widget/DropdownWidget.dart';

class ProfileEditPage extends StatefulWidget {

  static const String route = 'profileEdit';

  static const String title = 'Modifica profilo';

  @override
  State<ProfileEditPage> createState() => _ProfileEditPage();
}

class _ProfileEditPage extends State<ProfileEditPage> {

  final _formKey = GlobalKey<FormState>();

  final _usernameTextController = TextEditingController();
  final _nomeTextController = TextEditingController();
  final _cognomeTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwTextController = TextEditingController();
  final _newPswTextController = TextEditingController();
  final _chkPasswTextController = TextEditingController();

  String? chkPsw;
  late bool _boolImmagine;

  bool _initializationCompleted = false;
  bool _isProcessing = false;

  final spinnerItem = [
    '-',
    'g',
    'Kg',
    'cl',
    'L',
  ];

  late DocumentSnapshot<Object?> _oldData;

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
    final size = MediaQuery.of(context).size;
    if(_isProcessing){
      return CustomScaffold(
          title: ProfileEditPage.title,
          body: Center(
              child: CircularProgressIndicator(
                color: AppColors.sandBrown,
              )
          )
      );
    }else if (_initializationCompleted) {
      return CustomScaffold(
          title: ProfileEditPage.title,
          body: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                    fit: FlexFit.loose,
                    child: Row(
                      children: [
                        Container(
                          margin: EdgeInsets.only(top: 30, bottom: 30),
                          width: 150,
                          height: 150,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: _boolImmagine ? ImageLoader.currentUserImage():Image.asset('assets/images/icon_profile.png')
                          ),
                        ),
                        Column(
                            children: [
                              createButton(context),
                              deleteButton(context),
                            ]
                        )
                      ],
                    )
                ),
                Flexible(
                  fit: FlexFit.loose,
                  child: formBody(),
                ),
                editButton(context),
                //deleteButton(context)
              ],
            ),
          )
      );
    }else{
      return CustomScaffold(
          title: ProfileEditPage.title,
          body: DocumentStreamBuilder(
            stream: ProfileNetwork.getProfileInfo(),
            builder: (BuildContext builder, DocumentSnapshot<Object?> data){
              _nomeTextController.text = data['nome'];
              _cognomeTextController.text = data['cognome'];
              _usernameTextController.text = data['username'];
              _emailTextController.text = data['email'];
              _boolImmagine = data['boolImmagine'];
              _initializationCompleted = true;

              _oldData = data;

              return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 30, bottom: 30),
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: _boolImmagine ? ImageLoader.currentUserImage():Image.asset('assets/images/icon_profile.png')
                              ),
                            ),
                            Column(
                              children: [
                                createButton(context),
                                deleteButton(context),
                              ]
                            )
                          ],
                        )
                      ),
                      Flexible(
                        fit: FlexFit.loose,
                        child: formBody(),
                      ),
                    editButton(context),
                    //deleteButton(context),
                   ],
                  )
              );
            },
          )
      );
    }
  }

  Widget formBody(){
    return Form(
        key: _formKey,
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 20),
                child: TextFormFieldWidget.multiline(
                    controller: _usernameTextController,
                    validator: (value) => Validator.validateRequired(value: value),
                    label: 'Username',
                    hint: 'Inserire il nuovo username'),
            ),//Username
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 20),
                child: TextFormFieldWidget.multiline(
                    controller: _emailTextController,
                    validator: (value) => Validator.validateEmail(email: value),
                    label: 'Email',
                    hint: 'Inserire una nuova mail'),
            ),//Email
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 20),
                child: TextFormFieldWidget.multiline(
                    controller: _nomeTextController,
                    validator: (value) => Validator.validateNome(nome: value),
                    label: 'Nome',
                    hint: 'Inserire un nuovo nome'),
            ),//Nome
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 20),
                child: TextFormFieldWidget.multiline(
                    controller: _cognomeTextController,
                    validator: (value) => Validator.validateCognome(cognome: value),
                    label: 'Cognome',
                    hint: 'Inserire un nuovo cognome'),
            ),//Cognome
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 20),
                child: TextFormFieldWidget.psw(
                    controller: _passwTextController,
                    validator: (value) => Validator.validateRequired(value: value),
                    obscureText: true,
                    label: 'Password',
                    hint: 'Inserire password corrente'),
            ),//Password
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 20),
                child: TextFormFieldWidget.psw(
                    controller: _newPswTextController,
                    obscureText: true,
                    label: 'Nuova password',
                    hint: 'Lascia vuoto per non modificare'),
              ),//Nuova password
            Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 20),
                child: TextFormFieldWidget.psw(
                    controller: _chkPasswTextController,
                    obscureText: true,
                    validator: (value) => Validator.validateEqualPassword(
                        password: _newPswTextController.text, chkPassword: _chkPasswTextController.text),
                    label: 'Conferma nuova password',
                    hint: 'Lascia vuoto per non modificare'),
            ),//Conferma nuova password
          ],
        )
    );
  }

  // Button per salvare le modifiche al prodotto
  Widget editButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25),
        child: CustomButtons.submit('Salva Modifiche', onPressed: () async {

          if (_formKey.currentState!.validate()) {
            setState(() {
              _isProcessing = true;
            });

            Profile user = Profile(
              id: FirebaseAuth.instance.currentUser!.uid,
              username: _usernameTextController.text,
              nome: _nomeTextController.text,
              cognome: _cognomeTextController.text,
              email: _emailTextController.text,
              boolImmagine: false,
            );

            AuthCredential credential = EmailAuthProvider.credential(
                email: FirebaseAuth.instance.currentUser!.email!, password: _passwTextController.text);

            try{
              await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
              ProfileNetwork.updateProfile(user);
            }on FirebaseAuthException catch (e){
              _showAlertDialog(e as String);
            }


            setState(() {
              _isProcessing = false;
            });

            Navigation.back(context);
          }
        }));
  }

  // Button per eliminare il prodotto
  Widget deleteButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top:5, left:35, right: 15),
        child: CustomButtons.deleteSmall(
          'Elimina immagine',
          onPressed: () async {

            if (_formKey.currentState!.validate()) {
              setState(() {
                _isProcessing = true;
              });

              //ProductNetwork.deleteProduct(_oldData.id);

            }
          },
        )
    );
  }

  // Button per creare un nuovo prodotto
  Widget createButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top:5, left: 35, right: 15),
        child: CustomButtons.submitSmall(
          'Aggiungi immagine',
          onPressed: () async {

            if (_formKey.currentState!.validate()) {
              setState(() {
                _isProcessing = true;
              });

            }
          },
        ));
  }
}
