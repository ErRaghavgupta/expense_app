import 'package:expense_app2/Database/Appdatabase.dart';
import 'package:expense_app2/Models/usermodel.dart';
import 'package:expense_app2/Routes/routes.dart';
import 'package:expense_app2/customWidgets/textfield.dart';
import 'package:expense_app2/sharedpreference/local_storage.dart';
import 'package:flutter/material.dart';

class AccountView extends StatefulWidget {
  AccountView({super.key});

  @override
  State<AccountView> createState() => _AccountViewState();
}

class _AccountViewState extends State<AccountView> {
  String email = "", password = "", confirmPassword = "", mobileNo = "";

  FocusNode focusNode = FocusNode(),
      focusNode2 = FocusNode(),
      focusNode3 = FocusNode(),
      focusNode4 = FocusNode();

  var emailController = TextEditingController();

  var passwordController = TextEditingController();
  var confirmPasswordController = TextEditingController();
  var mobileNoController = TextEditingController();

  bool val = false;
  GlobalKey<FormState> _formkey = GlobalKey<FormState>();

  late AppDataBase dataBase;

  @override
  void initState() {
    super.initState();
    dataBase = AppDataBase.db;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amber,
        body: Form(
          key: _formkey,
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 50),
            shrinkWrap: true,
            children: [
              // Text("W"
              TextField2(
                text: "Email",
                hintText: "Enter an email",
                controller: emailController,
                onSaved: (value) {
                  email = value!;
                },
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email),
                textInputAction: TextInputAction.next,
                focusNode: focusNode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter a email";
                  } else {
                    return null;
                  }
                },
                onFieldSubmitted: (value) {
                  return FocusScope.of(context).requestFocus(focusNode2);
                },
              ),
              SizedBox(
                height: 40,
              ),
              TextField2(
                text: "Password",
                hintText: "Enter a password",
                controller: passwordController,
                onSaved: (value) {
                  password = value!;
                },
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(focusNode3),
                keyboardType: TextInputType.number,
                focusNode: focusNode2,
                textInputAction: TextInputAction.done,
                obscureText: !val,
                prefixIcon: Icon(Icons.lock),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "please enter a correct password";
                  } else {
                    return null;
                  }
                },
                suffixIcon: IconButton(
                  onPressed: () {
                    val = !val;
                    setState(() {});
                  },
                  icon:
                      val ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextField2(
                obscureText: !val,
                suffixIcon: IconButton(
                  onPressed: () {
                    val = !val;
                    setState(() {});
                  },
                  icon:
                      val ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                ),
                prefixIcon: Icon(Icons.lock),
                text: "Confirm Password",
                hintText: "Enter a Confirm Password",
                controller: confirmPasswordController,
                onSaved: (value) {
                  confirmPassword = value!;
                },
                keyboardType: TextInputType.number,
                validator: (val) {
                  if (val == null || val.isEmpty) {
                    return "Please enter a confirm password";
                  } else {
                    return null;
                  }
                },
                textInputAction: TextInputAction.next,
                focusNode: focusNode3,
                onFieldSubmitted: (value) =>
                    FocusScope.of(context).requestFocus(focusNode4),
              ),
              SizedBox(
                height: 20,
              ),
              TextField2(
                text: "MobileNo",
                hintText: "Enter a mobileNo",
                controller: mobileNoController,
                onSaved: (value) => value = mobileNo,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                focusNode: focusNode4,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "pls enter a mobile no";
                  } else {
                    return null;
                  }
                },
                prefixIcon: Icon(Icons.phone),
              ),
              SizedBox(
                height: 25,
              ),
              ElevatedButton(
                  onPressed: () async {
                    var memail = emailController.text.toString();
                    var mpassword = passwordController.text.toString();
                    var mconfirmPassword =
                        confirmPasswordController.text.toString();
                    var mmobileNo = mobileNoController.text.toString();

                    // print("kblbk");
                    if (memail != "" &&
                        mpassword != "" &&
                        mconfirmPassword != "" &&
                        mmobileNo != "") {
                      if (mpassword == mconfirmPassword) {
                        dataBase.createAccount(UserModel(
                            email: memail,
                            password: mpassword,
                            confirmPassword: mconfirmPassword,
                            mobileNo: mmobileNo));
                        Navigator.pushNamed(context, LOGIN_ROUTE);
                        var prefs = await Shared.getPrefs();
                        prefs.setBool(Shared().isLogin, true);
                      } else {
                        print("object");
                      }
                    } else {
                      print("787");
                    }
                  },
                  style: ElevatedButton.styleFrom(),
                  child: Text(
                    "Create an Account",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
