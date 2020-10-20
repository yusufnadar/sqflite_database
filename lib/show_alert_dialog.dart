import 'package:flutter/material.dart';
import 'package:flutter_app/database_helper.dart';
import 'package:flutter_app/kullanici_model.dart';
import 'package:flutter_app/provider.dart';
import 'package:provider/provider.dart';

class ShowAlertDialog{

  final gelenContext;
  final gelenDeger;
  DatabaseHelper databaseHelper = DatabaseHelper();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  ShowAlertDialog({this.gelenContext, this.gelenDeger}){
    showAlertDialog(gelenContext, gelenDeger);
  }

  showAlertDialog(BuildContext context, Kullanicilar gelenDeger) {
    final provider = Provider.of<SetState>(context,listen: false);
    String gelenKullaniciAdi;
    int gelenKullaniciYas;

    Widget ekleButon = FlatButton(
        child: Text("Ekle"),
        onPressed: () {
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            databaseHelper
                .kullaniciEkle(Kullanicilar(kullaniciAdi: gelenKullaniciAdi,
                kullaniciYas: gelenKullaniciYas))
                .then((value) {
                  provider.setState = true;
              Navigator.of(context).pop();
            });
          }
        }
    );
    Widget vazgecButon = FlatButton(
      child: Text("Vazgeç"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget guncelleButon = FlatButton(
      child: Text("Güncelle"),
      onPressed: () {
        if(formKey.currentState.validate()){
          formKey.currentState.save();
          databaseHelper
              .kullaniciGuncelle(Kullanicilar(
              kullaniciID: gelenDeger.kullaniciID,
              kullaniciAdi: gelenKullaniciAdi,
              kullaniciYas: gelenKullaniciYas),)
              .then((value) {
            provider.setState = true;
            Navigator.of(context).pop();
          });
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: gelenDeger != null ? Text("Eklenecek Kullanıcı") : Text(
          "Güncellenen Kullanıcı"),
      content: Form(
        key: formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              initialValue: gelenDeger != null ? gelenDeger.kullaniciAdi : "",
              onSaved: (kullaniciAdi) {
                gelenKullaniciAdi = kullaniciAdi;
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Kullanıcı Adı",
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              keyboardType: TextInputType.number,
              initialValue: gelenDeger != null ? gelenDeger.kullaniciYas
                  .toString() : "",
              onSaved: (kullaniciID) {
                gelenKullaniciYas = int.parse(kullaniciID);
              },
              decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                hintText: "Kullanıcı Yaşı",
              ),
            )
          ],
        ),
      ),
      actions: [
        gelenDeger == null ? ekleButon : guncelleButon,
        vazgecButon,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

}