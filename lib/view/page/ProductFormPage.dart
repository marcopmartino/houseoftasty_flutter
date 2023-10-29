
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:houseoftasty/utility/StreamBuilders.dart';
import 'package:houseoftasty/view/widget/CustomButtons.dart';
import 'package:houseoftasty/view/widget/TextWidgets.dart';
import 'package:intl/intl.dart';

import '../../Model/Product.dart';
import '../../utility/AppColors.dart';
import '../../utility/Navigation.dart';
import '../../utility/Validator.dart';

import '../../network/ProductNetwork.dart';

import '../widget/CustomDecoration.dart';
import '../widget/CustomScaffold.dart';
import '../widget/DropdownWidget.dart';

class ProductFormPage extends StatefulWidget {
  ProductFormPage({super.key}) {
    newProduct = true;
  }

  static const String route = 'productForm';

  ProductFormPage.edit({super.key, required this.productId}) {
    newProduct = false;
  }

  late final String? productId;
  late final bool newProduct;

  @override
  State<ProductFormPage> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductFormPage> {
  final _formKey = GlobalKey<FormState>();

  final _nomeTextController = TextEditingController();
  final _quantitaTextController = TextEditingController();
  final _misuraTextController = TextEditingController();
  final _dateTextController = TextEditingController();

  bool _initializationCompleted = false;
  bool _isProcessing = false;
  bool _noExpire = true;

  final spinnerItem = [
    '-',
    'g',
    'Kg',
    'cl',
    'L',
  ];

  late DocumentSnapshot<Object?> _oldData;

  final _focusNome = FocusNode();
  final _focusQuantita = FocusNode();
  final _focusMisura = FocusNode();
  final _focusDate = FocusNode();

  Future<void> _selectDate(String? startDate) async {
    DateTime? date = await showDatePicker(
        context: context,
        initialDate: startDate != null && startDate != '--/--/----'
            ? DateFormat('dd/MM/yyyy').parse(startDate)
            : DateTime.now(),
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        helpText: 'Seleziona una data di scadenza');

    if (date != null) {
      setState(() {
        _dateTextController.text = DateFormat('dd/MM/yyyy').format(date);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    _misuraTextController.text = '-';
    if(_noExpire) _dateTextController.text = '--/--/----';
    String title = widget.newProduct ? 'Aggiungi prodotto' : 'Modifica prodotto';
    if(_isProcessing){
      return CustomScaffold(
          title: title,
          body: Center(
            child: CircularProgressIndicator(
              color: AppColors.sandBrown,
            )
          )
      );
    }else if(widget.newProduct){
      return CustomScaffold(
          title: title,
          body: SingleChildScrollView(
            child: SizedBox(
              height: size.height-80,
              width: size.width,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Flexible(
                    fit: FlexFit.loose,
                    child: formBody(),
                  ),
                  createButton(context)
                ],
              ),
            ),
          )
      );
    } else if (_initializationCompleted) {
      return CustomScaffold(
          title: title,
          body: SizedBox(
            height: size.height-80,
            width: size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  fit: FlexFit.loose,
                  child: formBody(),
                ),
                editButton(context),
                deleteButton(context)
              ],
            ),
          )
      );
    }else{
      return CustomScaffold(
        title: title,
        body: DocumentStreamBuilder(
          stream: ProductNetwork.getProductById(widget.productId!),
          builder: (BuildContext builder, DocumentSnapshot<Object?> data){
            _nomeTextController.text = data['nome'];
            _quantitaTextController.text = data['quantita'];
            _misuraTextController.text = data['misura'];
            print(_misuraTextController.text);
            _dateTextController.text = data['scadenza'];
            if(_dateTextController.text != '--/--/----') _noExpire = false;
            _initializationCompleted = true;

            _oldData = data;

            return SingleChildScrollView(
              child: SizedBox(
                  height: size.height-80,
                  width: size.width,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(
                        fit: FlexFit.loose,
                        child: formBody(),
                      ),
                      editButton(context),
                      deleteButton(context),
                    ],
                  )
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
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 25, right: 25, top: 40, bottom: 40),
                child: TextFormFieldWidget.multiline(
                  controller: _nomeTextController,
                  validator: (value) => Validator.validateRequired(value: value),
                  label: 'Nome',
                  hint: 'Inserire nome prodotto/ingrediente'),
                ),
              ), //Nome
            Row(
              children: [
                Flexible(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 25,
                          right: 25,
                          top: 15,
                          bottom: 0),
                      child: TextFormFieldWidget.numeric(
                        controller: _quantitaTextController,
                        validator: (value) => Validator.validateRequired(value: value),
                        label: 'Quantità',
                        hint: 'Inserire quantità')
                    ),
                ),
                Flexible(
                  flex: 2,
                  child: DropdownWidget(
                        controller: _misuraTextController,
                        items: spinnerItem),
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
                        padding:
                        const EdgeInsets.only(
                            left: 25.0,
                            right: 20.0,
                            top: 50,
                            bottom: 0),
                        child: TextFormField(
                            controller:_dateTextController,
                            readOnly: true,
                            style: TextStyle(color: Colors.black),
                            textAlign: TextAlign.center,
                            decoration: CustomDecoration.dataLabelDecoration(),
                            onTap: () {
                              _selectDate(_dateTextController.text);
                              _noExpire = false;
                            }),
                      ),
                    )),
                Flexible(
                    flex: 2,
                    child: Padding(
                        padding:
                        const EdgeInsets.only(
                            right: 35,
                            top: 50,
                            bottom: 0),
                        child: CheckboxListTile(
                          title: Text(
                              'Senza scadenza'),
                          checkColor:
                          AppColors.sandBrown,
                          value: _noExpire,
                          onChanged: (val) {
                            setState(() {
                              _noExpire = val!;
                              print(_noExpire);
                              if (_noExpire ==
                                  true) {
                                _dateTextController
                                    .text =
                                '--/--/----';
                              }
                            });
                          },
                        )))
              ],
            ), //Scadenza
          ],
        )
    );
  }

  // Button per creare un nuovo prodotto
  Widget createButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(bottom: 200),
        child: CustomButtons.submit(
          'Aggiungi prodotto',
          onPressed: () async {
            _focusNome.unfocus();
            _focusQuantita.unfocus();
            _focusMisura.unfocus();
            _focusDate.unfocus();

            if (_formKey.currentState!.validate()) {
              setState(() {
                _isProcessing = true;
              });

              await ProductNetwork.addProduct(Product(
                nome: _nomeTextController.text,
                quantita: _quantitaTextController.text,
                misura: _misuraTextController.text,
                scadenza: _dateTextController.text,
              ).toMap());

              Navigation.back(context);
            }
          },
        ));
  }

  // Button per salvare le modifiche al prodotto
  Widget editButton(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(left: 25, right: 25, top: 25, bottom: 25),
        child: CustomButtons.submit('Salva Modifiche', onPressed: () async {
          _focusNome.unfocus();
          _focusQuantita.unfocus();
          _focusMisura.unfocus();
          _focusDate.unfocus();

          if (_formKey.currentState!.validate()) {
            setState(() {
              _isProcessing = true;
            });

            Product product = Product(
              id: widget.productId!,
              nome: _nomeTextController.text,
              quantita: _quantitaTextController.text,
              misura: _misuraTextController.text,
              scadenza: _dateTextController.text,
            );

            ProductNetwork.updateProduct(product);

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
        padding: EdgeInsets.only(bottom: 175),
        child: CustomButtons.delete(
          'Elimina prodotto',
          onPressed: () async {
            _focusNome.unfocus();
            _focusQuantita.unfocus();
            _focusMisura.unfocus();
            _focusDate.unfocus();

            if (_formKey.currentState!.validate()) {
              setState(() {
                _isProcessing = true;
              });

              ProductNetwork.deleteProduct(_oldData.id);

              Navigation.back(context);
            }
          },
        )
    );
  }
}
