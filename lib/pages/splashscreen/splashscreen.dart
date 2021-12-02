import 'dart:async';

import 'package:aplikasi_antrian/attribute/color.dart';
import 'package:aplikasi_antrian/attribute/duration.dart';
import 'package:aplikasi_antrian/attribute/size.dart';
import 'package:aplikasi_antrian/pages/mainpage/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(splashScreenDuration, () async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (prefs.getString("logo") == null) {
        await prefs.setString("logo", "");
      }
      if (prefs.getString("instansi") == null) {
        await prefs.setString("instansi", "");
      }
      if (prefs.getString("alamat") == null) {
        await prefs.setString("alamat", "");
      }
      if (prefs.getString("bawah") == null) {
        await prefs.setString("bawah", "");
      }
      if (prefs.getInt("no") == null) {
        await prefs.setInt("no", 0);
      }
      if (prefs.getString("history") == null) {
        await prefs.setString("history", "[]");
      }
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MainPage(),
          ),
          (route) => false);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: splashScreenBackgroundColor,
        body: Center(
            child: SizedBox(
          width: screenWidth(context) * 0.55,
          height: screenWidth(context) * 0.50,
          child: Image.asset("assets/printer.png"),
        )));
  }
}
