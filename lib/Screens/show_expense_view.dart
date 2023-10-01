import 'package:expense_app2/Bloc/expense_bloc.dart';
import 'package:expense_app2/Routes/routes.dart';
import 'package:expense_app2/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Models/expense_model.dart';
import '../customWidgets/textfield.dart';
import '../sharedpreference/local_storage.dart';

class ShowExpenseView extends StatefulWidget {
  const ShowExpenseView({super.key});

  @override
  State<ShowExpenseView> createState() => _ShowExpenseViewState();
}

class _ShowExpenseViewState extends State<ShowExpenseView> {
  var amountController = TextEditingController();
  var focusNode3 = FocusNode(), focusNode2 = FocusNode();
  var descController = TextEditingController();

  var listCatType = ["Debit", "Credit"];

  var selectCartType = "Debit";
  var selectCategoriesIndex = -1;

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        // leading: Text("Cancel"),
        title: Text(
          "Expenses",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            text2(context, "desc", "Enter a desc"),
            SizedBox(
              height: 25,
            ),
            text3(context, "amount", "Enter a amount"),
          ],
        ),
      ),
      bottomSheet: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          DropdownButton(
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
          ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
                    return GridView.builder(
                      padding: EdgeInsets.symmetric(vertical: 25),
                      shrinkWrap: true,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
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
                          AppConstants.categories[selectCategoriesIndex]["img"],
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
                      textScaleFactor: 1.1,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
          ElevatedButton(
              style: ElevatedButton.styleFrom(),
              onPressed: () async {
                var prefs = await Shared.getPrefs();
                BlocProvider.of<ExpenseBloc>(context).add(AddExpenseEvent(
                    model: ExpenseModel(
                        u_id: prefs.getInt(Shared().userId)!,
                        expenseTitle: AppConstants
                            .categories[selectCategoriesIndex]["name"],
                        expenseDesc: descController.text.toString(),
                        expense_cat_id: AppConstants
                            .categories[selectCategoriesIndex]["id"],
                        expense_time: DateTime.now().toString(),
                        expense_type: selectCartType == "Debit" ? 0 : 1,
                        expenseBal: 0,
                        expense_amt:
                            int.parse(amountController.text.toString()))));
                descController.clear();
                amountController.clear();
                Navigator.pushNamedAndRemoveUntil(
                    context, GRAPH_ROUTE, (route) => false);
              },
              child: Text(
                "Save",
                // textScaleFactor: 1.3,
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              )),
        ],
      ),
    );
  }

// // for filtering a data with date wise
//
// void filteringExpenseByDate(List<ExpenseModel> arrExpense) {
//   arrDateWiseExpense.clear();
//   List<String> eachUniqueDates = [];
//   for (ExpenseModel eachExp in arrExpense) {
//     var eachDate = DateTime.parse(eachExp.expense_time);
//     var mDate =
//         "${eachDate.year}-${eachDate.month.toString().length < 2 ? "0${eachDate.month}" : "${eachDate.month}"}-${eachDate.day}";
//
//     if (!eachUniqueDates.contains(mDate)) {
//       eachUniqueDates.add(mDate);
//     }
//     // print(eachUniqueDates);
//   }
//
//   ///step 2,
//
//   for (String eachExp in eachUniqueDates) {
//     List<ExpenseModel> eachDataExpense = [];
//     num eachDateAmount = 0;
//     for (ExpenseModel eachModel in arrExpense) {
//       if (eachModel.expense_time.contains(eachExp)) {
//         eachDataExpense.add(eachModel);
//         if (eachModel.expense_type == 0) {
//           //debit
//           eachDateAmount = eachDateAmount - eachModel.expense_amt;
//         } else {
//           // credit
//           eachDateAmount = eachDateAmount + eachModel.expense_amt;
//         }
//       }
//       // print(eachDateAmount);
//
//       arrDateWiseExpense.add(FilteredExpenseModel(
//           dateName: eachExp,
//           eachDateAmt: eachDateAmount,
//           arrExpenses: eachDataExpense));
//       // print(arrDateWiseExpense.length);
//     }
//   }
// }
//
// // for filtering a month wise data
//
// void filteringMonthWiseExpense(List<ExpenseModel> expenses) {
//   arrMonthWiseExpense.clear();
//   List<String> eachUniqueMonth = [];
//   for (ExpenseModel model in expenses) {
//     var eachMonth = DateTime.parse(model.expense_time);
//     var month =
//         "${eachMonth.year}-${eachMonth.month.toString().length < 2 ? "0${eachMonth.month}" : "${eachMonth.month}"}";
//
//     if (!eachUniqueMonth.contains(month)) {
//       eachUniqueMonth.add(month);
//     }
//   }
//
//   // step 2;
//   for (String uniqueMonths in eachUniqueMonth) {
//     List<ExpenseModel> expenseModel = [];
//     num eachMonthAmount = 0;
//     for (ExpenseModel model in expenses) {
//       if (model.expense_time.contains(uniqueMonths)) {
//         expenseModel.add(model);
//
//         if (model.expense_type == 0) {
//           // debit
//           eachMonthAmount = eachMonthAmount - model.expense_amt;
//         } else {
//           eachMonthAmount = eachMonthAmount + model.expense_amt;
//         }
//       }
//     }
//     arrMonthWiseExpense.add(FilteredExpenseModel(
//         dateName: uniqueMonths,
//         eachDateAmt: eachMonthAmount,
//         arrExpenses: expenseModel));
//   }
// }
//
// // for filtering year wise data
//
// void filteringYearWiseExpense(List<ExpenseModel> arrExpense) {
//   List<String> eachUniqueYear = [];
//   for (ExpenseModel model in arrExpense) {
//     var mYear = DateTime.parse(model.expense_time);
//     var year = "${mYear.year}";
//     print(year);
//     if (!eachUniqueYear.contains(year)) {
//       eachUniqueYear.add(year);
//     }
//   }
//   // step 2
//
//   for (String eachYear in eachUniqueYear) {
//     num eachYearAmount = 0;
//     List<ExpenseModel> eachExpenseYear = [];
//     for (ExpenseModel model in arrExpense) {
//       if (model.expense_time.contains(eachYear)) {
//         eachExpenseYear.add(model);
//
//         if (model.expense_type == 0) {
//           //debit
//           eachYearAmount = eachYearAmount - model.expense_amt;
//         } else {
//           eachYearAmount = eachYearAmount + model.expense_amt;
//         }
//       }
//     }
//     arrYearWiseExpense.add(FilteredExpenseModel(
//         dateName: eachYear,
//         eachDateAmt: eachYearAmount,
//         arrExpenses: eachExpenseYear));
//   }
//   // arrYearWiseExpense.add(FilteredExpenseModel(dateName: , eachDateAmt: , arrExpenses: arrExpenses))
// }

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
