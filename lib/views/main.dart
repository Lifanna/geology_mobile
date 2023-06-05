import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:flutter_application_1/views/geology/home_page.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'login/login_page.dart';


void main() {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  loginState() async{
    final storage = FlutterSecureStorage();
    String? _userID = await storage.read(key: "accessToken");
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Геология',
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  SplashScreen() : super();

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  loginState() async{
    final storage = FlutterSecureStorage();
    String? _userID = await storage.read(key: "userID");
  }

  final String? _userID = "";

  @override
  void initState() {
    super.initState();
    _startApp();
  }

  Future<void> _startApp() async {
    final storage = FlutterSecureStorage();

    String? userID = await StorageService().readSecureData("accessToken");

    if (userID == null) {
      await Navigator.push(
        context, MaterialPageRoute(builder: (_) => LoginPage(title: "Авторизация")));
    } else {
      await Navigator.push(
        context, MaterialPageRoute(builder: (_) => HomePage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: loginState(),
      builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        return _userID != null?
        HomePage()
        :LoginPage(title: "Авторизация");
    },);
  }
}