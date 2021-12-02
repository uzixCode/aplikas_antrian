import 'package:aplikasi_antrian/attribute/size.dart';
import 'package:aplikasi_antrian/models/historymod.dart';
import 'package:aplikasi_antrian/pages/printerpage/printerpage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  final formatter = DateFormat('dd/MM/yyyy H:m');
  bool isLoading = true;
  SharedPreferences? prefs;
  List<Historymod> history = [];
  void initDataBase() async {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: screenWidth(context) * 0.80,
                  child: Card(
                      child: ListTile(
                    onTap: () async => await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PrintBluetooth(
                                  data: history[index],
                                ))),
                    leading: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(history[(history.length - 1) - index]
                            .no
                            .toString()),
                      ],
                    ),
                    title: Text(history[(history.length - 1) - index].nama),
                    subtitle: Text(
                      formatter.format(
                          history[(history.length - 1) - index].tanggal),
                    ),
                  )),
                );
              }),
    );
  }
}
