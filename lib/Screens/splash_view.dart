import 'package:expense_app2/Routes/routes.dart';
import 'package:expense_app2/sharedpreference/local_storage.dart';
import 'package:flutter/material.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  bool valid = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(seconds: 2), () {
      // Navigator.pushNamed(context, CREATE_ACCOUNT_ROUTE);
      getBoolData();
    });
  }

  void getBoolData() async {
    var prefs = await Shared.getPrefs();
    valid = prefs.getBool(Shared().isLogin) == null
        ? false
        : prefs.getBool(Shared().isLogin)!;
    if (valid == false) {
      Navigator.pushReplacementNamed(context, CREATE_ACCOUNT_ROUTE);
    } else {
      Navigator.pushReplacementNamed(context, LOGIN_ROUTE);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.amberAccent,
        body: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/Images/5501371.png",
                height: 80,
                width: 80,
                color: Colors.black,
              ),
              SizedBox(
                height: 25,
              ),
              Text(
                "Welcome to Expense App",
                textScaleFactor: 1.5,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              )
            ],
          ),
        ),
      ),
    );
  }
}
