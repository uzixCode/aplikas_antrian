import 'dart:io';
import 'dart:typed_data';
import 'package:aplikasi_antrian/attribute/color.dart';
import 'package:aplikasi_antrian/attribute/size.dart';
import 'package:aplikasi_antrian/models/historymod.dart';
import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image/image.dart' as ig;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrintBluetooth extends StatefulWidget {
  PrintBluetooth({required this.data});
  final Historymod data;

  @override
  State<PrintBluetooth> createState() => _PrintBluetoothState();
}

class _PrintBluetoothState extends State<PrintBluetooth> {
  PrinterBluetoothManager printerManager = PrinterBluetoothManager();
  List<PrinterBluetooth> allPrinters = [];
  List<bool> isSelecteds = [];
  final formatter = DateFormat('dd/MM/yyyy H:m');
  void scanPrinters() async {
    printerManager.startScan(Duration(seconds: 4));
  }

  void stopScanPrinters() async {
    printerManager.stopScan();
  }

  void initPrinters() async {
    if (!await printerManager.isScanningStream.first) {
      printerManager.startScan(Duration(seconds: 4));
    }

    printerManager.scanResults.listen((printers) async {
      allPrinters = printers;
      isSelecteds.clear();
      for (var item in allPrinters) {
        isSelecteds.add(false);
      }
      setState(() {});
      print(printers);
    });
  }

  void selectPrinter(PrinterBluetooth printer) {
    printerManager.selectPrinter(printer);
  }

  void printTicket() async {
    await printerManager.printTicket(
        await ticket(PaperSize.mm58, await CapabilityProfile.load()));
  }

  Future<List<int>> ticket(PaperSize paper, CapabilityProfile profile) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final Generator ticket = Generator(paper, profile);
    List<int> bytes = [];
    if (prefs.getString("logo")!.length > 0) {
      final Uint8List image =
          await File(prefs.getString("logo")!).readAsBytes();
      final ig.Image? readyImage = ig.decodeImage(image);

      bytes += ticket.image(
        ig.copyResize(readyImage!,
            height: (paper.width.toDouble() * 0.50).round(),
            width: (paper.width.toDouble() * 0.50).round()),
        align: PosAlign.center,
      );
    }
    bytes += ticket.emptyLines(1);
    if (prefs.getString("instansi")!.length > 0) {
      bytes += ticket.text(prefs.getString("instansi")!,
          styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size2,
              fontType: PosFontType.fontB),
          linesAfter: 1);
    }
    if (prefs.getString("alamat")!.length > 0) {
      bytes += ticket.text(prefs.getString("alamat")!,
          styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              fontType: PosFontType.fontA),
          linesAfter: 1);
    }
    bytes += ticket.hr();
    bytes += ticket.emptyLines(1);
    bytes += ticket.text(widget.data.no.toString(),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            fontType: PosFontType.fontA),
        linesAfter: 1);
    if (widget.data.nama.length > 0) {
      bytes += ticket.text(widget.data.nama,
          styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              fontType: PosFontType.fontA),
          linesAfter: 1);
    }
    if (prefs.getString("bawah")!.length > 0) {
      bytes += ticket.text(prefs.getString("bawah")!,
          styles: PosStyles(
              align: PosAlign.center,
              height: PosTextSize.size1,
              width: PosTextSize.size1,
              fontType: PosFontType.fontA),
          linesAfter: 0);
    }
    bytes += ticket.hr();

    bytes += ticket.text(formatter.format(widget.data.tanggal),
        styles: PosStyles(
            align: PosAlign.center,
            height: PosTextSize.size1,
            width: PosTextSize.size1,
            fontType: PosFontType.fontA),
        linesAfter: 0);

    bytes += ticket.hr();
    bytes += ticket.emptyLines(1);
    return bytes;
  }

  @override
  void initState() {
    initPrinters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: StreamBuilder<bool>(
          stream: printerManager.isScanningStream,
          builder: (context, snapshot) {
            return FloatingActionButton(
              backgroundColor:
                  (snapshot.data ?? false) ? Colors.red : Colors.green,
              onPressed: () {
                snapshot.data! ? stopScanPrinters() : scanPrinters();
              },
              child: Icon(
                (snapshot.data ?? false) ? Icons.stop : Icons.search,
              ),
            );
          }),
      bottomNavigationBar: !isSelecteds.contains(true)
          ? null
          : InkWell(
              onTap: () async {
                printTicket();
              },
              child: SizedBox(
                height: kBottomNavigationBarHeight,
                width: screenWidth(context) * 0.80,
                child: Card(
                  color: tambahAntrianButtonColor,
                  child: Center(
                      child: Text(
                    "Print",
                    style: TextStyle(
                        color: tambahAntrianTextColor,
                        fontSize: kBottomNavigationBarHeight * 0.40),
                  )),
                ),
              ),
            ),
      body: StreamBuilder<List<PrinterBluetooth>>(
          stream: printerManager.scanResults,
          builder: (context, snapshot) {
            return ListView.builder(
              itemCount: snapshot.data == null ? 0 : snapshot.data!.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    onTap: () {
                      selectPrinter(snapshot.data![index]);
                      isSelecteds[index] = true;
                      setState(() {});
                    },
                    title: Text(snapshot.data![index].name!),
                    subtitle: Text(snapshot.data![index].address!),
                    trailing: !isSelecteds[index]
                        ? null
                        : Icon(
                            Icons.check,
                            color: Colors.green,
                          ),
                  ),
                );
              },
            );
          }),
    );
  }
}
