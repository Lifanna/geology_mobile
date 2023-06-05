import 'package:flutter/material.dart';
import 'package:flutter_application_1/controllers/home_controller.dart';
import 'package:flutter_application_1/models/api_models.dart';
import 'package:flutter_application_1/models/storage_item.dart';
import 'package:flutter_application_1/services/status_code.dart';
import 'package:flutter_application_1/services/storage_service.dart';
import 'package:flutter_application_1/views/geology/home_page.dart';



class LoginPage extends StatefulWidget {
  LoginPage({super.key, required this.title});

  final String title;

  @override
  State<LoginPage> createState() => _LoginPageState();

  final HomeController _homeController = HomeController();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool passwordVisible = true;
  bool _isLoading = false;
  bool _isError = false;

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Авторизация"),
        centerTitle: true,
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Логин пользователя',
                  hintText: 'Введите ваш логин',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextField(
                  controller: passwordController,
                  obscureText: passwordVisible,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Пароль пользователя',
                  hintText: 'Введите ваш пароль',
                  suffixIcon: IconButton(
                     icon: Icon(passwordVisible
                         ? Icons.visibility
                         : Icons.visibility_off),
                     onPressed: () {
                       setState(
                         () {
                           passwordVisible = !passwordVisible;
                         },
                       );
                     },
                   ),
                ),
              ),
            ),
            TextButton(
              onPressed: (){
                //TODO FORGOT PASSWORD SCREEN GOES HERE
              },
              child: Text(
                'Забыли пароль?',
                style: TextStyle(color: Colors.blue, fontSize: 15),
              ),
            ),
            Container(
              height: 50,
              width: 250,
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(20)),
              child: TextButton(
                onPressed: () async {
                  setState(() {
                      _isLoading = true;
                      _isError = false;
                    });

                  String username = usernameController.text;
                  String password = passwordController.text;

                  StatusCode statusCode = await widget._homeController.loginUser(username, password);

                  if (statusCode.statusCode == "200") {
                    setState(() {
                      _isLoading = false;
                      _isError = false;
                    });
                    Navigator.push(
                      context, MaterialPageRoute(builder: (_) => HomePage()));
                  }
                  else {
                    setState(() {
                      _isLoading = false;
                      _isError = true;
                    });
                  }
                },
                child: _isLoading ?
                Container(
                  width: 24,
                  height: 24,
                  padding: const EdgeInsets.all(2.0),
                  child: const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 3,
                  ),
                ) : Text(
                  'Войти',
                  style: TextStyle(color: Colors.white, fontSize: 25),
                ),
              ),
            ),
            SizedBox(
              child: Visibility(
                visible: _isError,
                child: Text(
                  "Произошла ошибка, повторите позднее",
                  style: TextStyle(
                    color: Colors.redAccent,
                  )
                ),
              ),
              height: 130,
            ),
          ],
        ),
      ),
    );
  }
}
