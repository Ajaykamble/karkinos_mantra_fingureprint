import 'dart:developer';

import 'package:flutter/material.dart';
import 'dart:async';
import 'package:karkinos_mantra_fingerprint/karkinos_mantra_fingerprint.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with SingleTickerProviderStateMixin {
  String _platformVersion = 'Unknown';
  final _karkinosMantraFingerprintPlugin = KarkinosMantraFingerprint();

  @override
  void initState() {
    super.initState();
    initPlatformState();
    //getVerion();
  }

  Future<void> getVerion() async {
    try {
      String platformVersion;
      platformVersion = await _karkinosMantraFingerprintPlugin.getPlatformVersion() ?? "";
      setState(() {
        _platformVersion = platformVersion;
      });
    } catch (e) {
      print(e);
    }
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      String wadh = "E0jzJ/P8UopUHAieZn8CKqS4WPMi5ZSYXgfnlfkWjrc=";
      String pidoptions = '<PidOptions ver="1.0"> <Opts fCount="1" fType="2" pCount="0" format="0" pidVer="2.0" wadh=\'' + wadh + '\' timeout="20000"  posh="UNKNOWN" env="P" /> </PidOptions>';
      platformVersion = await _karkinosMantraFingerprintPlugin.captureFingurePrint(pidOptions: pidoptions) ?? "";
      log("${platformVersion}");
    } on ClientNotFound catch (e) {
      log("${e.code}");
      platformVersion = 'Install Clinet';
    } catch (e) {
      platformVersion = 'Failed to get platform version. $e';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
              child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
