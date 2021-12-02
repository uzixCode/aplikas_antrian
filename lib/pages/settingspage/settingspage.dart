import 'dart:io';

import 'package:aplikasi_antrian/attribute/color.dart';
import 'package:aplikasi_antrian/attribute/size.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool isLoading = true;
  SharedPreferences? prefs;

  void initDataBase() async {
    prefs = await SharedPreferences.getInstance();
    instansi.text = prefs!.getString("instansi")!;
    alamat.text = prefs!.getString("alamat")!;
    bawah.text = prefs!.getString("bawah")!;
    isLoading = false;

    setState(() {});
  }

  @override
  void initState() {
    initDataBase();
    super.initState();
  }

  final instansi = TextEditingController();
  final alamat = TextEditingController();
  final bawah = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: InkWell(
        onTap: () async {
          await prefs!.setInt("no", 0);
          await prefs!.setString("history", "[]");
        },
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          width: screenWidth(context) * 0.80,
          child: Card(
            color: tambahAntrianButtonColor,
            child: Center(
                child: Text(
              "Reset Antrian",
              style: TextStyle(
                  color: tambahAntrianTextColor,
                  fontSize: kBottomNavigationBarHeight * 0.40),
            )),
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).padding.top,
                ),
                Expanded(
                  child: SingleChildScrollView(
                      child: Center(
                    child: Column(
                      children: [
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        Text(
                          "Logo",
                          style:
                              TextStyle(fontSize: screenWidth(context) * 0.06),
                        ),
                        SizedBox(
                          height: screenHeight(context) * 0.02,
                        ),
                        Stack(
                          clipBehavior: Clip.none,
                          children: [
                            InkWell(
                              onTap: () {
                                if (prefs!.getString("logo")!.length > 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Hero(
                                        tag: "image",
                                        child: InteractiveViewer(
                                            child: Image.file(File(
                                                prefs!.getString("logo")!))),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: Hero(
                                tag: "image",
                                child: SizedBox(
                                  width: screenWidth(context) * 0.40,
                                  height: screenWidth(context) * 0.40,
                                  child: Card(
                                    elevation: 5,
                                    color:
                                        tambahAntrianButtonColor.withAlpha(100),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            screenWidth(context) * 0.05)),
                                    child: prefs!.getString("logo")!.length <= 0
                                        ? Icon(
                                            Icons.image,
                                            color: Colors.white,
                                            size: screenWidth(context) * 0.30,
                                          )
                                        : Container(
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        screenWidth(context) *
                                                            0.05),
                                                image: DecorationImage(
                                                    fit: BoxFit.cover,
                                                    image: Image.file(File(
                                                            prefs!.getString(
                                                                "logo")!))
                                                        .image)),
                                          ),
                                  ),
                                ),
                              ),
                            ),
                            Positioned(
                                left: -5,
                                bottom: -5,
                                child: InkWell(
                                  onTap: () async {
                                    await prefs!.setString("logo", "");
                                    setState(() {});
                                  },
                                  child: SizedBox(
                                    width: screenWidth(context) * 0.12,
                                    height: screenWidth(context) * 0.12,
                                    child: Card(
                                        elevation: 5,
                                        color: tambahAntrianButtonColor
                                            .withAlpha(255),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                screenWidth(context) * 0.02)),
                                        child: Icon(
                                          Icons.cancel,
                                          size: screenWidth(context) * 0.07,
                                          color: Colors.white,
                                        )),
                                  ),
                                )),
                            Positioned(
                                right: -5,
                                bottom: -5,
                                child: InkWell(
                                  onTap: () async {
                                    final ImagePicker _picker = ImagePicker();
                                    final XFile? image = await _picker
                                        .pickImage(source: ImageSource.gallery);
                                    if (image != null) {
                                      await prefs!
                                          .setString("logo", image.path);
                                      setState(() {});
                                    }
                                  },
                                  child: SizedBox(
                                    width: screenWidth(context) * 0.12,
                                    height: screenWidth(context) * 0.12,
                                    child: Card(
                                        elevation: 5,
                                        color: tambahAntrianButtonColor
                                            .withAlpha(255),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                screenWidth(context) * 0.02)),
                                        child: Icon(
                                          Icons.add_a_photo,
                                          size: screenWidth(context) * 0.07,
                                          color: Colors.white,
                                        )),
                                  ),
                                ))
                          ],
                        ),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: instansi,
                                      decoration: InputDecoration(
                                          hintText: "Masukan Nama Instansi",
                                          label: Text("Instansi")),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        await prefs!.setString(
                                            "instansi", instansi.text);
                                      },
                                      child: Card(
                                          color: tambahAntrianButtonColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: screenWidth(context) * 0.10,
                                            ),
                                          )))
                                ])),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: alamat,
                                      decoration: InputDecoration(
                                          hintText: "Masukan Alamat",
                                          label: Text("Alamat")),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        await prefs!
                                            .setString("alamat", alamat.text);
                                      },
                                      child: Card(
                                          color: tambahAntrianButtonColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: screenWidth(context) * 0.10,
                                            ),
                                          )))
                                ])),
                        Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 20, horizontal: 5),
                            child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: bawah,
                                      decoration: InputDecoration(
                                          hintText:
                                              "Masukan Kata-Kata Paling Bawah",
                                          label: Text("Kata-Kata")),
                                    ),
                                  ),
                                  InkWell(
                                      onTap: () async {
                                        await prefs!
                                            .setString("bawah", bawah.text);
                                      },
                                      child: Card(
                                          color: tambahAntrianButtonColor,
                                          child: Padding(
                                            padding: const EdgeInsets.all(10),
                                            child: Icon(
                                              Icons.add,
                                              color: Colors.white,
                                              size: screenWidth(context) * 0.10,
                                            ),
                                          )))
                                ])),
                      ],
                    ),
                  )),
                ),
              ],
            ),
    );
  }
}
