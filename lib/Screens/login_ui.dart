import 'package:expense_app2/Database/Appdatabase.dart';
import 'package:expense_app2/Models/usermodel.dart';
import 'package:expense_app2/Routes/routes.dart';
import 'package:expense_app2/customWidgets/textfield.dart';
import 'package:flutter/material.dart';

class LoginUi extends StatefulWidget {
  const LoginUi({super.key});

  @override
  State<LoginUi> createState() => _LoginUiState();
}

class _LoginUiState extends State<LoginUi> {
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  bool value = false;

  var focusNode1 = FocusNode();
  var focusNode2 = FocusNode();
  String email = "", password = "";

  late AppDataBase myDb;

  @override
  void initState() {
    super.initState();
    myDb = AppDataBase.db;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange,
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          "LoginScreen",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        shrinkWrap: true,
        children: [
          TextField2(
            text: "Email",
            hintText: "Enter a email",
            controller: emailController,
            onSaved: (value) {
              password = value!;
            },
            focusNode: focusNode1,
            textInputAction: TextInputAction.next,
            keyboardType: TextInputType.emailAddress,
            onFieldSubmitted: (value) {
              return FocusScope.of(context).requestFocus(focusNode2);
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a correct email";
              } else {
                return null;
              }
            },
            prefixIcon: Icon(Icons.email),
          ),
          SizedBox(
            height: 30,
          ),
          TextField2(
            text: "Password",
            focusNode: focusNode2,
            hintText: "Enter a password",
            controller: passwordController,
            onSaved: (value) {
              password = value!;
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "Please enter a password";
              } else {
                return null;
              }
            },
            textInputAction: TextInputAction.done,
            obscureText: !value,
            prefixIcon: Icon(Icons.lock),
            suffixIcon: IconButton(
              onPressed: () {
                value = !value;
                setState(() {});
              },
              icon: value ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
            ),
          ),
          SizedBox(
            height: 25,
          ),
          ElevatedButton(
              onPressed: () async {
                var mail = emailController.text.toString();
                var pass = passwordController.text.toString();

                if (mail != "" && pass != "") {
                  if ((await myDb.authenticateUser(mail, pass)) == true) {
                    emailController.clear();
                    passwordController.clear();
                    Navigator.pushNamed(context, ADD_EXPENSES_ROUTE);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            "your email and password is incorect",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        );
                      },
                    );
                  }
                } else {
                  return;
                }
              },
              child: Text(
                "Login",
                textScaleFactor: 1.5,
                style: TextStyle(fontWeight: FontWeight.bold),
              ))
        ],
      ),
    );
  }
}
