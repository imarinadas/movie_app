import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movies_app_flutter/model/boxes.dart';
import 'package:movies_app_flutter/model/towatch.dart';

class AddTowatchScreen extends StatefulWidget {
  AddTowatchScreen({Key? key}) : super(key: key);

  @override
  _AddTowatchScreenState createState() =>
      _AddTowatchScreenState();
}

class _AddTowatchScreenState extends State<AddTowatchScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  validated() {
    if (_formKey.currentState != null &&
        _formKey.currentState!.validate()) {
      _onFormSubmit();
      print("Form Validated");
    } else {
      print("Form not validated");
      return;
    } }

  late String title;
  late String release;

  void _onFormSubmit(){
    Box<Towatch> towatchlistBox = Hive.box<Towatch>(HiveBoxex.towatch);
    towatchlistBox.add(Towatch(title: title, release: release));
    Navigator.of(context).pop();
    print(towatchlistBox);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add To Watch'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (String? value) {
                      if (value == null || value.trim().length == 0) {
                        return "Required";
                      }
                      return null;
                    },
                    onChanged: (value){
                      title = value;
                    },
                  ),
                  TextFormField(
                    autofocus: false,
                    decoration: InputDecoration(labelText: 'Release'),
                    validator: (String? value) {
                      if (value == null || value.trim().length == 0) {
                        return "Required";
                      }
                      return null;
                    },
                    onChanged: (value){
                      release = value;
                    },
                  ),
                  ElevatedButton(
                      onPressed: () {
                        validated();
                      },
                      child: Text('Add To Watch'))
                ],),
            )),
      ),);
  }}