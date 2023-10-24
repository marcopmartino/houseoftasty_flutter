import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'utility/AppColors.dart';
import 'utility/CustomDecoration.dart';
import 'utility/Validator.dart';

import 'network/ProductNetwork.dart';

import 'Model/Product.dart';
import 'ProductsPage.dart';

class EditProductPage extends StatefulWidget {
  const EditProductPage({super.key, this.productId});

  final String? productId;

  @override
  _EditProductPageState createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  @override
  void initState() {
    super.initState();
  }

  final _formKey = GlobalKey<FormState>();

  final _nomeTextController = TextEditingController();
  final _quantitaTextController = TextEditingController();
  final _misuraTextController = TextEditingController();
  final _dateTextController = TextEditingController();

  final spinnerItem = [
    '-',
    'g',
    'Kg',
    'cl',
    'L',
  ];

  var spinnerValue = '-';

  bool _isProcessing = false;
  bool _noExpire = true;
  bool done = false;

  final _focusNome = FocusNode();
  final _focusQuantita = FocusNode();
  final _focusMisura = FocusNode();
  final _focusDate = FocusNode();

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

  Future<void> _selectDate(String? startDate) async {

    DateTime? date = await showDatePicker(
        context: context,
        initialDate: startDate != null && startDate != '--/--/----'?
          DateFormat('dd/MM/yyyy').parse(startDate) : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        helpText: 'Seleziona una data di scadenza'
    );

    if(date != null){
      setState(() {
        _dateTextController.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  @override
  Widget build(BuildContext context){
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppColors.sandBrown,
      appBar: AppBar(
        title: widget.productId != null
            ? Text('Modifica prodotto')
            : Text('Aggiungi prodotto')
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: ProductNetwork.products.doc(widget.productId).get() ,
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }else{
            if(!done){
              _nomeTextController.text = snapshot.data!['nome'];
              _quantitaTextController.text = snapshot.data!['quantita'];
              if(snapshot.data!['misura'] != ''){
                spinnerValue = snapshot.data!['misura'];
              }
              if(snapshot.data!['scadenza'] != '--/--/----') {
                _noExpire = false;
              }
              _dateTextController.text = snapshot.data!['scadenza'];
              done = true;
            }
            return SizedBox(
                height: size.height-80,
                width: size.width,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Flexible(
                        fit: FlexFit.loose,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              fit: FlexFit.loose,
                              child: Form(
                                  key: _formKey,
                                  child: Column(
                                    children: [
                                      Flexible(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 25, right: 25, top: 20, bottom: 40),
                                          child: TextFormField(
                                            controller: _nomeTextController,
                                            validator: (value) => Validator.validateRequired(value: value),
                                            style: TextStyle(color: Colors.black),
                                            decoration: CustomDecoration.productInputDecoration('Nome', 'Inserire nome prodotto/ingrediente'),
                                          ),
                                        ),
                                      ), //Nome
                                      Row(
                                        children: [
                                          Flexible(
                                              flex: 2,
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 25, right: 25, top: 15, bottom: 0),
                                                child: TextFormField(
                                                  controller: _quantitaTextController,
                                                  validator: (value) => Validator.validateRequired(value: value),
                                                  style: TextStyle(color: Colors.black),
                                                  decoration: CustomDecoration.productInputDecoration('Quantità', 'Inserire quantità'),
                                                  keyboardType: TextInputType.number,
                                                ),
                                              )
                                          ),
                                          Flexible(
                                              flex: 2,
                                              child: SizedBox(
                                                width: 90,
                                                child: DropdownButtonFormField(
                                                  padding: EdgeInsets.only(top: 15, bottom: 0),
                                                  decoration: CustomDecoration.dropDownInputDecoration(),
                                                  style: TextStyle(
                                                      color: Colors.black, //Font color
                                                      fontSize: 20 //font size on dropdown button
                                                  ),
                                                  dropdownColor: AppColors.sandBrown,
                                                  iconSize: 24,
                                                  value: spinnerValue,
                                                  items: spinnerItem.map((String item) {
                                                    return DropdownMenuItem(
                                                        value: item, child: Text(item));
                                                  }).toList(),
                                                  onChanged: (String? newValue) {
                                                    _misuraTextController.text = newValue!;
                                                    setState(() {
                                                      spinnerValue = newValue;
                                                    });
                                                  },
                                                ),
                                              )
                                          )
                                        ],
                                      ), //Quantità e misura
                                      Row(
                                        children: [
                                          Flexible(
                                              flex: 2,
                                              child: SizedBox(
                                                width: 200,
                                                child: Padding(
                                                  padding: const EdgeInsets.only(
                                                      left: 25.0,
                                                      right: 25.0,
                                                      top: 50,
                                                      bottom: 0),
                                                  child: TextFormField(
                                                      controller: _dateTextController,
                                                      style: TextStyle(color: Colors.black),
                                                      decoration: CustomDecoration.dataLabelDecoration(),
                                                      readOnly: true,
                                                      onTap: (){
                                                        _selectDate(snapshot.data!['scadenza']);
                                                        _noExpire = false;
                                                      }
                                                  ),
                                                ),
                                              )
                                          ),
                                          Flexible(
                                            flex: 2,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                right: 35,
                                                top: 50,
                                                bottom: 0
                                              ),
                                              child: CheckboxListTile(
                                                title: Text('Senza scadenza'),
                                                checkColor: AppColors.sandBrown,
                                                value: _noExpire,
                                                onChanged: (val){
                                                  setState(() {
                                                    _noExpire = val!;
                                                    print(_noExpire);
                                                    if(_noExpire == true){
                                                      _dateTextController.text = '--/--/----';
                                                    }
                                                  });
                                                },
                                              )
                                            )
                                          )
                                        ],
                                      ), //Scadenza
                                      _isProcessing? CircularProgressIndicator() :
                                      Flexible(
                                        flex: 1,
                                        child: widget.productId !=null ?
                                          Column(
                                            children: [
                                              Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25, right: 25, top: 25, bottom: 0
                                                  ),
                                                  child: ElevatedButton(
                                                      onPressed: () async {
                                                        _focusNome.unfocus();
                                                        _focusQuantita.unfocus();
                                                        _focusMisura.unfocus();
                                                        _focusDate.unfocus();

                                                        if (_formKey.currentState!.validate()) {
                                                          setState(() {
                                                            _isProcessing = true;
                                                          });

                                                          Object? result =
                                                          await ProductNetwork.editProduct(
                                                            id: widget.productId!,
                                                            nome: _nomeTextController.text,
                                                            quantita: _quantitaTextController.text,
                                                            misura: _misuraTextController.text,
                                                            scadenza: _dateTextController.text,
                                                          );

                                                          setState(() {
                                                            _isProcessing = false;
                                                          });

                                                          if (result == null) {
                                                            if (context.mounted) {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          ProductsPage()),
                                                                      (Route route) => false);
                                                            }
                                                          } else {
                                                            _showAlertDialog(
                                                                'Errore modifica prodotto: $result');
                                                          }
                                                        }
                                                      },
                                                      style: CustomDecoration.textButtonDecoration(false),
                                                      child: Text(
                                                        'SALVA MODIFICHE',
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 20),
                                                      )
                                                  )
                                              ), //Bottone modifica
                                              Padding(
                                                padding: EdgeInsets.only(
                                                  left: 25, right: 25, top: 25, bottom: 0
                                                ),
                                                child: ElevatedButton(
                                                  onPressed: () async {
                                                    _focusNome.unfocus();
                                                    _focusQuantita.unfocus();
                                                    _focusMisura.unfocus();
                                                    _focusDate.unfocus();

                                                    if (_formKey.currentState!.validate()) {
                                                      setState(() {
                                                        _isProcessing = true;
                                                      });

                                                      Object? result = await ProductNetwork.deleteProduct(
                                                          id: widget.productId!,
                                                      );

                                                      setState(() {
                                                        _isProcessing = false;
                                                      });

                                                      if (result == null) {
                                                        if (context.mounted) {
                                                          Navigator.pushAndRemoveUntil(context,
                                                            MaterialPageRoute(builder: (_) =>
                                                                ProductsPage()), (Route route) => false);
                                                        }
                                                      } else {
                                                        _showAlertDialog('Errore eliminazione prodotto: $result');
                                                      }
                                                    }
                                                 },
                                                  style: CustomDecoration.textButtonDecoration(true),
                                                  child: Text(
                                                    'ELIMINA PRODOTTO',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20),
                                                  ))) //Bottone Elimina
                                            ],
                                          ) :
                                          Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 25, right: 25, top: 25, bottom: 0
                                                  ),
                                                  child: ElevatedButton(
                                                      onPressed: () async {
                                                        _focusNome.unfocus();
                                                        _focusQuantita.unfocus();
                                                        _focusMisura.unfocus();
                                                        _focusDate.unfocus();

                                                        if (_formKey.currentState!.validate()) {
                                                          setState(() {
                                                            _isProcessing = true;
                                                          });

                                                          Object? result =
                                                          await ProductNetwork.editProduct(
                                                            id: widget.productId!,
                                                            nome: _nomeTextController.text,
                                                            quantita: _quantitaTextController.text,
                                                            misura: _misuraTextController.text,
                                                            scadenza: _dateTextController.text,
                                                          );

                                                          setState(() {
                                                            _isProcessing = false;
                                                          });

                                                          if (result == null) {
                                                            if (context.mounted) {
                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (_) =>
                                                                          ProductsPage()),
                                                                      (Route route) => false);
                                                            }
                                                          } else {
                                                            _showAlertDialog(
                                                                'Errore modifica prodotto: $result');
                                                          }
                                                        }
                                                      },
                                                      style: CustomDecoration.textButtonDecoration(false),
                                                      child: Text(
                                                        'SALVA MODIFICHE',
                                                        style: TextStyle(
                                                            color: Colors.white, fontSize: 20),
                                                      )
                                                  )
                                              ), //Bottone aggiungi
                                      )
                                    ],
                                  )
                              ),
                            )
                          ],
                        )
                    )
                  ],
                )
            );
          }
        },
      )
    );
  }
}