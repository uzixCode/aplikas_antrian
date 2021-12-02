// To parse this JSON data, do
//
//     final historymod = historymodFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

List<Historymod> historymodFromJson(String str) =>
    List<Historymod>.from(json.decode(str).map((x) => Historymod.fromJson(x)));

String historymodToJson(List<Historymod> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Historymod {
  Historymod({
    required this.nama,
    required this.no,
    required this.tanggal,
  });

  final String nama;
  final int no;
  final DateTime tanggal;

  factory Historymod.fromJson(Map<String, dynamic> json) => Historymod(
        nama: json["nama"],
        no: json["no"],
        tanggal: DateTime.parse(json["tanggal"]),
      );

  Map<String, dynamic> toJson() => {
        "nama": nama,
        "no": no,
        "tanggal": tanggal.toIso8601String(),
      };
}
