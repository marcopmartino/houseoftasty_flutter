import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/network/ProfileNetwork.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/widget/CustomButtons.dart';
import 'package:houseoftasty/view/widget/TextWidgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../model/Profile.dart';
import '../../network/StorageNetwork.dart';
import '../../utility/AppColors.dart';
import '../../utility/ImageLoader.dart';
import '../../utility/Navigation.dart';
import '../../utility/OperationType.dart';
import '../../utility/Validator.dart';

import '../widget/CustomEdgeInsets.dart';
import '../widget/CustomScaffold.dart';

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

  Image _defaultImage = ImageLoader.asset('user_image_default.png');
  File? _imageFile;
  Image? get _image => _imageFile != null ? ImageLoader.path(_imageFile!.path) : _defaultImage;

  OperationType _lastOperation = OperationType.NONE;

  final spinnerItem = [
    '-',
    'g',
    'Kg',
    'cl',
    'L',
  ];

  late DocumentSnapshot<Object?> _oldData;

  Future _showAlertDialog(FirebaseAuthException error) async {

    print(error.code);

    return showDialog(
        context: context,
        builder: (BuildContext context) {

          void dismissDialog() {
            Navigation.back(context);
          }

          return AlertDialog(
              title: Text('Errore modifica profilo'),
              content: error.code == 'wrong-password' ?
                Text('Password inserita errata.') :
                error.code == 'too-many-requests' ?
                  Text('Troppe richieste, riprovare più tardi') : Text('Errore generico'),
              actionsPadding: EdgeInsets.symmetric(horizontal: 16),
              actionsAlignment: MainAxisAlignment.spaceBetween,
              actions: [
                TextButton(
                    child: Text('Ok'),
                    onPressed:  () {
                      dismissDialog();
                    }),
              ]);
        });
  }

  @override
  Widget build(BuildContext context) {
    if(_isProcessing){
      return CustomScaffold(
          title: ProfileEditPage.title,
          body: Center(
              child: CircularProgressIndicator(
                color: AppColors.caramelBrown,
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
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: CustomEdgeInsets.fromLTRB(10, 30, 0, 30),
                          width: 150,
                          height: 150,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(50.0),
                              child: getImage()
                          ),
                        ),
                        Column(
                            children: [
                              imageSelectionButton(context),
                              imageRemovalButton(context),
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
            stream: ProfileNetwork.getCurrentUserInfo(),
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
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              margin: CustomEdgeInsets.fromLTRB(10, 30, 0, 30),
                              width: 150,
                              height: 150,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(50.0),
                                  child: _boolImmagine ? ImageLoader.currentUserImage():Image.asset('assets/images/icon_profile.png')
                              ),
                            ),
                            Column(
                              children: [
                                imageSelectionButton(context),
                                imageRemovalButton(context),
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

  // Button per salvare le modifiche al profilo
  Widget editButton(BuildContext context) {
    void navigateBack() {
      Navigation.back(context);
    }

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
              boolImmagine: _lastOperation == OperationType.SELECTED || (_lastOperation == OperationType.NONE && _boolImmagine),
            );

            AuthCredential credential = EmailAuthProvider.credential(
                email: FirebaseAuth.instance.currentUser!.email!, password: _passwTextController.text);

            try{
              await FirebaseAuth.instance.currentUser!.reauthenticateWithCredential(credential);
              ProfileNetwork.updateProfile(user);
              if (_lastOperation == OperationType.SELECTED) {
                await StorageNetwork.uploadProfileImage(file: _imageFile!, filename: _oldData.id);
              } else if (_lastOperation == OperationType.REMOVED && _boolImmagine) {
                await StorageNetwork.deleteProfileImage(filename: _oldData.id);
                navigateBack();
              }
            }on FirebaseAuthException catch (e){
              _showAlertDialog(e);
            }


            setState(() {
              _isProcessing = false;
            });
          }
        }));
  }

  // Button per eliminare la foto profilo
  Widget imageRemovalButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top:5, left:35, right: 15),
        child: CustomButtons.deleteSmall(
          'Elimina immagine',
          onPressed: () async {
            if(_imageFile != null || (_lastOperation == OperationType.NONE && _boolImmagine)){
              removeImage();
            }
          },
        )
    );
  }

  // Button per aggiungere una foto profilo
  Widget imageSelectionButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top:5, left: 35, right: 15),
        child: CustomButtons.submitSmall(
          'Modifica immagine',
          onPressed: () {
            ImageLoader.device(
              context,
              callback: (pickedImage) =>
                  updateImage(pickedImage));
          }
        ));
  }

  void removeImage() {
    setState(() {
      _lastOperation = OperationType.REMOVED;
      _imageFile = null;
    });
  }

  void updateImage(PickedFile? pickedFile) {
    if (pickedFile != null) {
      setState(() {
        _lastOperation = OperationType.SELECTED;
        _imageFile = File(pickedFile.path);
      });
    }
  }

  StatefulWidget? getImage() {
    if (_lastOperation == OperationType.NONE && _boolImmagine) {
      return ImageLoader.firebaseProfileStorageImage(FirebaseAuth.instance.currentUser!.uid);
    } else {
      return _image;
    }
  }

}
