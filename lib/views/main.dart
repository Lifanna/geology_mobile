import 'dart:async';

import 'package:flutter/material.dart';
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
    String? _userID = await storage.read(key: "userID");
  }

  final String? _userID = "";

  @override
  Widget build(BuildContext context) {
    // return FutureBuilder(
    //   // future: StorageService().readSecureData("userID"),
    //   future: loginState(),
    //   builder: (BuildContext context, AsyncSnapshot<String?> userID) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Геология',
          home: SplashScreen(),
          // home: (_userID != null) ? HomePage(userID: _userID,) : LoginPage(title: 'Авторизация')
        );
        // return userID != null
        // ?HomePage(userID: "asdasd",)
        // :LoginPage(title: "Авторизация");
      // });    // home: LoginPage(title: 'Геология страница'),
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
    _startApp();
    super.initState();
    // Timer(Duration(seconds: 2),
    //         ()=>Navigator.pushReplacement(context,
    //         MaterialPageRoute(builder:
    //             (context) =>
    //             HomePage()
    //         )
    //     )
    // );
  }

  Future<void> _startApp() async {
    final storage = FlutterSecureStorage();
    String? userID = await storage.read(key: "userID");
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
    return Scaffold(
      body: Center(
        child: Text("Загрузка..."),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return FutureBuilder(
  //     future: loginState(),
  //     builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
  //       return _userID != null?HomePage(userID: snapshot.data)
  //       :LoginPage(title: "Авторизация");
  //   },);
  // }
}