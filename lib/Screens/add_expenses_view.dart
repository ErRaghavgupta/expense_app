import 'package:expense_app2/Bloc/expense_bloc.dart';
import 'package:expense_app2/Models/expense_model.dart';
import 'package:expense_app2/Routes/routes.dart';
import 'package:expense_app2/constants/app_constants.dart';
import 'package:expense_app2/customWidgets/textfield.dart';
import 'package:expense_app2/sharedpreference/local_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddExpenseView extends StatefulWidget {
  AddExpenseView({super.key});

  @override
  State<AddExpenseView> createState() => _AddExpenseViewState();
}

class _AddExpenseViewState extends State<AddExpenseView> {
  var titleController = TextEditingController();

  var descController = TextEditingController();

  var amountController = TextEditingController();

  var focusNode = FocusNode(),
      focusNode2 = FocusNode(),
      focusNode3 = FocusNode();

  var listCatType = ["Debit", "Credit"];

  var selectCartType = "Debit";

  var selectCategoriesIndex = -1;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        centerTitle: true,
        title: Text(
          "Add Expense View",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      // backgroundColor: Colors.amberAccent,?
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
        child: Column(
          // shrinkWrap: true,
          // padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
          children: [
            text(context, "title", "Enter a title"),
            SizedBox(
              height: 15,
            ),
            text2(context, "desc", "Enter a desc"),
            SizedBox(
              height: 15,
            ),
            text3(context, "amount", "Enter a amount"),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return GridView.builder(
                          padding: EdgeInsets.symmetric(vertical: 25),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 4),
                          itemCount: AppConstants.categories.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap: () {
                                selectCategoriesIndex = index;
                                setState(() {});
                                Navigator.pop(context);
                              },
                              child: Column(
                                children: [
                                  Image.asset(
                                    AppConstants.categories[index]["img"],
                                    height: 30,
                                    width: 30,
                                  ),
                                  Text(AppConstants.categories[index]["name"])
                                ],
                              ),
                            );
                          },
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      // padding: EdgeInsets.symmetric(horizontal: 50, vertical: 10),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15))),
                  child: selectCategoriesIndex >= 0
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          // mainAxisAlignment: MainAxisAlignment.,
                          children: [
                            Image.asset(
                              AppConstants.categories[selectCategoriesIndex]
                                  ["img"],
                              height: 30,
                              width: 30,
                            ),
                            SizedBox(
                              width: 15,
                            ),
                            Text(AppConstants.categories[selectCategoriesIndex]
                                ["name"])
                          ],
                        )
                      : Text(
                          "Choose category",
                          textScaleFactor: 1.5,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        )),
            ),
            SizedBox(
              height: 15,
            ),
            DropdownButton(
              // isDense: true,
              borderRadius: BorderRadius.circular(15),
              padding: EdgeInsets.symmetric(horizontal: 15),
              value: selectCartType,
              items: listCatType.map((e) {
                return DropdownMenuItem(
                  value: e,
                  child: Text(e),
                );
              }).toList(),
              onChanged: (value) {
                selectCartType = value!;
                setState(() {});
              },
            ),
            SizedBox(
              height: 25,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.cyan.shade300),
                  onPressed: () async {
                    var prefs = await Shared.getPrefs();
                    BlocProvider.of<ExpenseBloc>(context).add(AddExpenseEvent(
                        model: ExpenseModel(
                            u_id: prefs.getInt(Shared().userId)!,
                            expenseTitle: titleController.text.toString(),
                            expenseDesc: descController.text.toString(),
                            expense_cat_id: AppConstants
                                .categories[selectCategoriesIndex]["id"],
                            expense_time: DateTime.now().toString(),
                            expense_type: selectCartType == "Debit" ? 0 : 1,
                            expenseBal: 0,
                            expense_amt:
                                int.parse(amountController.text.toString()))));
                    titleController.clear();
                    descController.clear();
                    amountController.clear();
                    Navigator.pushNamed(context, SHOW_EXPENSE_ROUTE);
                  },
                  child: Text(
                    "Add transactions",
                    textScaleFactor: 1.3,
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  )),
            )
          ],
        ),
      ),
    ));
  }

  Widget text(BuildContext context, String title, String hint) {
    return TextField2(
      text: title,
      hintText: hint,
      controller: titleController,
      textInputAction: TextInputAction.next,
      focusNode: focusNode,
      onFieldSubmitted: (value) {
        return FocusScope.of(context).requestFocus(focusNode2);
      },
      keyboardType: TextInputType.name,
    );
  }

  Widget text2(BuildContext context, String title, String hint) {
    return TextField2(
      text: title,
      hintText: hint,
      controller: descController,
      textInputAction: TextInputAction.next,
      focusNode: focusNode2,
      onFieldSubmitted: (value) {
        return FocusScope.of(context).requestFocus(focusNode3);
      },
      keyboardType: TextInputType.name,
    );
  }

  Widget text3(BuildContext context, String title, String hint) {
    return TextField2(
      text: title,
      hintText: hint,
      controller: amountController,
      textInputAction: TextInputAction.done,
      focusNode: focusNode3,
      keyboardType: TextInputType.number,
    );
  }
}
