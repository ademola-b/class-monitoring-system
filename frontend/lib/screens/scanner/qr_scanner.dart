import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:frontend/utils/defaultText.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class Scan extends StatefulWidget {
  const Scan({super.key});

  @override
  State<Scan> createState() => _ScanState();
}

class _ScanState extends State<Scan> {
  bool isScanCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              DefaultText(text: "Place QR Code in the area"),
              DefaultText(text: "Scanning will be automatically started"),
            ],
          )),
          Expanded(
              flex: 4,
              child: Stack(

                children: [MobileScanner(
                  allowDuplicates: true,
                  onDetect: (barcode, args) {
                  if (!isScanCompleted) {
                    String code = barcode.rawValue ?? '------';
                    isScanCompleted = true;
                    Navigator.pushNamed(context, '/result');
                  }
                }),
                
                ],
              ))
        ],
      ),
    ));
  }
}