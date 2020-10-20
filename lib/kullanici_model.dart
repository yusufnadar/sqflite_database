class Kullanicilar {
  int kullaniciID;
  int kullaniciYas;
  String kullaniciAdi;

  Kullanicilar({this.kullaniciID,this.kullaniciYas,this.kullaniciAdi});

  Kullanicilar.fromMap(Map<String,dynamic> map )
  : kullaniciID = map["kullaniciID"],
   kullaniciYas = map["kullaniciYas"],
   kullaniciAdi = map["kullaniciAdi"];

  Map<String, dynamic> toMap() {
    return {
      "kullaniciID": kullaniciID,
      "kullaniciYas": kullaniciYas,
      "kullaniciAdi": kullaniciAdi,
    };
  }
}