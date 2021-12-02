import 'package:aplikasi_antrian/attribute/color.dart';
import 'package:aplikasi_antrian/attribute/size.dart';
import 'package:aplikasi_antrian/main.dart';
import 'package:aplikasi_antrian/models/historymod.dart';
import 'package:aplikasi_antrian/pages/historypage/historypage.dart';
import 'package:aplikasi_antrian/pages/printerpage/printerpage.dart';
import 'package:aplikasi_antrian/pages/settingspage/settingspage.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool isLoading = true;
  SharedPreferences? prefs;
  List<Historymod> history = [];
  void initDataBase() async {
    isLoading = true;
    setState(() {});
    prefs = await SharedPreferences.getInstance();

    history = historymodFromJson(prefs!.getString("history")!);

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    initDataBase();
    super.initState();
  }

  final nama = TextEditingController();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: tambahAntrianButtonColor,
        title: Text("Aplikasi Antrian"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
                onTap: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage(),
                      ));
                  initDataBase();
                },
                child: Icon(Icons.settings)),
          )
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () async {
          scaffoldKey.currentState!
              .showBottomSheet((context) => UnconstrainedBox(
                    child: SizedBox(
                      width: screenWidth(context),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: nama,
                                  decoration: InputDecoration(
                                      hintText: "Masukan Nama",
                                      label: Text("Nama")),
                                ),
                              ),
                              InkWell(
                                onTap: () async {
                                  int? current = prefs!.getInt("no");
                                  await prefs!.setInt("no", current! + 1);
                                  history.add(Historymod(
                                      nama: nama.text,
                                      no: prefs!.getInt("no")!,
                                      tanggal: DateTime.now()));
                                  await prefs!.setString(
                                      "history", historymodToJson(history));
                                  setState(() {});
                                  nama.clear();
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => PrintBluetooth(
                                                data: history.last,
                                              )));
                                  Navigator.pop(context);
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
                                    )),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
        },
        child: SizedBox(
          height: kBottomNavigationBarHeight,
          width: screenWidth(context) * 0.80,
          child: Card(
            color: tambahAntrianButtonColor,
            child: Center(
                child: Text(
              "Tambah Antrian",
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
          : Center(
              child: InkWell(
                onTap: () async {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => HistoryPage()));
                },
                child: SizedBox(
                    height: screenWidth(context) * 0.50,
                    width: screenWidth(context) * 0.50,
                    child: Card(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              screenWidth(context) * 0.02)),
                      child: Center(
                          child: Text(
                        prefs!.getInt("no").toString(),
                        style: TextStyle(fontSize: screenWidth(context) * 0.10),
                      )),
                    )),
              ),
            ),
    );
  }
}
