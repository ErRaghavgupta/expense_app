import 'package:expense_app2/Screens/graph_view.dart';
import 'package:expense_app2/Screens/setting_view.dart';
import 'package:flutter/material.dart';

class AddExpenseView extends StatefulWidget {
  AddExpenseView({super.key});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  var bottomList = [
    GraphView(),
    Setting(),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: bottomList.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.wallet), label: "Wallet"),
          BottomNavigationBarItem(icon: Icon(Icons.graphic_eq), label: "graph"),
        ],
        onTap: (value) {
          _selectedIndex = value;
          setState(() {});
        },
      ),
    ));
  }
}
