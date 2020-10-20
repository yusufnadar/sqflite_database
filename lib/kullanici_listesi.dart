import 'package:flutter/material.dart';
import 'package:flutter_app/database_helper.dart';
import 'package:flutter_app/kullanici_model.dart';
import 'package:flutter_app/provider.dart';
import 'package:flutter_app/show_alert_dialog.dart';
import 'package:provider/provider.dart';

class KullaniciListesi extends StatefulWidget {
  @override
  _KullaniciListesiState createState() => _KullaniciListesiState();
}

class _KullaniciListesiState extends State<KullaniciListesi> {

  List<Kullanicilar> tumKullanicilar;
  DatabaseHelper databaseHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<SetState>(context);
    if(provider.setState == true){
      setState(() {

      });
    }
    return FutureBuilder<List<Kullanicilar>>(
      future: databaseHelper.kullanicilariListeHalindeGetir(),
      builder: (BuildContext context,
          AsyncSnapshot<List<Kullanicilar>> snapshot) {
        if (snapshot.hasData) {
          var gelenKullanici = snapshot.data;
          return ListView.builder(
              shrinkWrap: true,
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    ShowAlertDialog(gelenContext: context, gelenDeger:gelenKullanici[index]);
                  },
                  title: Text(gelenKullanici[index].kullaniciAdi,style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  subtitle: Text(gelenKullanici[index].kullaniciYas.toString(),style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold),),
                  leading: Text((index + 1).toString(),style: TextStyle(fontWeight: FontWeight.bold),),
                  trailing: IconButton(
                    icon: Icon(Icons.delete,color: Colors.red,),
                    onPressed: () {
                      databaseHelper.kullaniciSil(gelenKullanici[index].kullaniciID);
                      setState(() {

                      });
                    },
                  ),
                );
              });
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }


}
