import 'package:expense_app2/Bloc/expense_bloc.dart';
import 'package:expense_app2/Database/Appdatabase.dart';
import 'package:expense_app2/Routes/routes.dart';
import 'package:expense_app2/Screens/create_account_view.dart';
import 'package:expense_app2/Screens/add_expenses_view.dart';
import 'package:expense_app2/Screens/login_ui.dart';
import 'package:expense_app2/Screens/show_expense_view.dart';
import 'package:expense_app2/Screens/splash_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(BlocProvider<ExpenseBloc>(
    create: (context) {
      return ExpenseBloc(db: AppDataBase.db);
    },
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Expense App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      onGenerateRoute: (settings) {
        if (settings.name == INITIAL_ROUTE) {
          return MaterialPageRoute(
            builder: (context) => SplashView(),
          );
        } else if (settings.name == CREATE_ACCOUNT_ROUTE) {
          return MaterialPageRoute(
            builder: (context) => AccountView(),
          );
        } else if (settings.name == LOGIN_ROUTE) {
          return MaterialPageRoute(
            builder: (context) => LoginUi(),
          );
        } else if (settings.name == GRAPH_ROUTE) {
          return MaterialPageRoute(
            builder: (context) => AddExpenseView(),
          );
        } else if (settings.name == SHOW_EXPENSE_ROUTE) {
          return MaterialPageRoute(
            builder: (context) => ShowExpenseView(),
          );
        }
        return null;
      },

      // home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
