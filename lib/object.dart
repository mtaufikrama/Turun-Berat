class TiapHari {
  String? hari;
  String? jam;
  Data? data;

  TiapHari({this.hari, this.jam, this.data});

  TiapHari.fromJson(Map<String, dynamic> json) {
    hari = json['hari'];
    jam = json['jam'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['hari'] = hari;
    data['jam'] = jam;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  String? image;
  String? berat;

  Data({this.image, this.berat});

  Data.fromJson(Map<String, dynamic> json) {
    image = json['image'];
    berat = json['berat'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['image'] = image;
    data['berat'] = berat;
    return data;
  }
}
