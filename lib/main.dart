import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:movies_app_flutter/screens/home_screen.dart';
import 'package:sizer/sizer.dart';
import 'utils/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Movie App',
          theme: ThemeData.dark().copyWith(
            primaryColor: kPrimaryColor,
            scaffoldBackgroundColor: kPrimaryColor,
          ),
          home: MyLoginPage(),
        );
      },
    );
  }
}

  class MyLoginPage extends StatefulWidget {
    @override
    _MyLoginPageState createState() => _MyLoginPageState();
  }

  class _MyLoginPageState extends State<MyLoginPage> {
    final username_controller = TextEditingController();
    final password_controller = TextEditingController();
    late SharedPreferences logindata;
    late bool newuser;

    @override
    void initState() {
      super.initState();
      check_if_already_login();
    }

    void check_if_already_login() async {
      logindata = await SharedPreferences.getInstance();
      newuser = (logindata.getBool('login') ?? true);
      print(newuser);
      if (newuser == false) {
        Navigator.pushReplacement(
        context, new MaterialPageRoute(builder: (context) => HomeScreen()));
      } }

      @override
      void dispose() {
        username_controller.dispose();
        password_controller.dispose();
        super.dispose();
      }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Movie App"),
        ),
        body: Center(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
              "Login Form",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: username_controller,
                  decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'username',),
                ),),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: TextField(
                  controller: password_controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'password',),
                  ),),
               RaisedButton(
                 textColor: Colors.white,
                 color: Colors.blue, onPressed: () {
                  String username = username_controller.text;
                  String password = password_controller.text;
                  if (username != '' && password != '') {
                  print('Successfull');
                  logindata.setBool('login', false);
                  logindata.setString('username', username);
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context) => HomeScreen()));
                  }
                },
                child: Text("LOG IN"),)
      ],),
      ),);
  }

}
