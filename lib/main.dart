import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/database_helper.dart';
import 'package:flutter_app/kullanici_listesi.dart';
import 'package:flutter_app/kullanici_model.dart';
import 'package:flutter_app/provider.dart';
import 'package:flutter_app/show_alert_dialog.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SetState(),
        ),
      ],
      child: MaterialApp(
        home: MyApp(),
        debugShowCheckedModeBanner: false,
      ),
    ),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Kullanicilar> tumKullanicilar;
  DatabaseHelper databaseHelper = DatabaseHelper();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          FloatingActionButton.extended(
            backgroundColor: Colors.red,
            onPressed: () {
              databaseHelper.tumKullanicilariSil().then((value) {
                if(value != 0){
                  _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("$value kullanıcı silindi",),duration: Duration(seconds: 1),));
                  setState(() {
                  });
                }else _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text("Silinecek kullanıcı yok "),duration: Duration(seconds: 1),));
              });
            },
            label: Text("Tüm Kullanıcıları Sil"),
          ),
          FloatingActionButton.extended(
            onPressed: () {
              ShowAlertDialog(gelenContext:context,gelenDeger: null);
            },
            label: Text("Kullanıcı Ekle"),
          ),
        ],
      ),
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text("Kullanıcı Listesi"),
        centerTitle: true,
      ),
      body: KullaniciListesi(),
    );
  }

}


