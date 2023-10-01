import 'package:expense_app2/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/expense_bloc.dart';
import '../Models/expense_model.dart';
import '../Models/filtered_expense_model.dart';
import '../constants/app_constants.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
  List<FilteredExpenseModel> arrDateWiseExpense = [];
  List<FilteredExpenseModel> arrMonthWiseExpense = [];
  List<FilteredExpenseModel> arrYearWiseExpense = [];
  num totalDateAmount = 0;
  num totalMonthAmount = 0;
  num totalYearAmount = 0;

  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.white,
              leading: Container(),
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.black,
                    child: IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, SHOW_EXPENSE_ROUTE);
                        },
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        )),
                  ),
                )
              ],
            ),
            body: BlocBuilder<ExpenseBloc, ExpenseState>(
              builder: (context, state) {
                if (state is ExpenseLoadingState) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ExpenseErrorState) {
                  return Center(child: Text(state.errorMessage));
                } else if (state is ExpenseLoadedState) {
                  filteringExpenseByDate(state.listExpense);
                  // filteringMonthWiseExpense(state.listExpense);
                  return state.listExpense.isNotEmpty
                      ? ListView(
                          children: [
                            Container(
                              height: 200,
                              child: Center(
                                child: Text(
                                  "\$$totalDateAmount",
                                  textScaleFactor: 1.5,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: arrDateWiseExpense.length,
                              itemBuilder: (context, index) {
                                final data = arrDateWiseExpense[index];
                                return Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text(
                                          data.dateName,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          data.eachDateAmt.toString(),
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: data.arrExpenses.length,
                                      itemBuilder: (context, childIndex) {
                                        final currItems =
                                            data.arrExpenses[childIndex];
                                        var imagePath = AppConstants.categories
                                            .firstWhere((element) =>
                                                element["id"] ==
                                                currItems
                                                    .expense_cat_id)["img"];
                                        return ListTile(
                                          leading: Image.asset(imagePath),
                                          title: Text(currItems.expenseTitle),
                                          subtitle: Text(currItems.expenseDesc),
                                          trailing: Text(
                                              currItems.expense_amt.toString()),
                                        );
                                      },
                                    )
                                  ],
                                );
                              },
                            ),
                          ],
                        )
                      : Center(
                          child: Text(
                            "Add Expenses",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            textScaleFactor: 1.5,
                          ),
                        );
                }
                return Container();
              },
            )));
  }

  // for filtering a data with date wise

  void filteringExpenseByDate(List<ExpenseModel> arrExpense) {
    totalDateAmount = 0;
    arrDateWiseExpense.clear();
    List<String> eachUniqueDates = [];
    for (ExpenseModel eachExp in arrExpense) {
      var eachDate = DateTime.parse(eachExp.expense_time);
      var mDate =
          "${eachDate.year}-${eachDate.month.toString().length < 2 ? "0${eachDate.month}" : "${eachDate.month}"}-${eachDate.day.toString().length < 2 ? "0${eachDate.day}" : "${eachDate.day}"}";

      if (!eachUniqueDates.contains(mDate)) {
        eachUniqueDates.add(mDate);
      }
      // print(eachUniqueDates);
    }

    ///step 2,

    for (String eachExp in eachUniqueDates) {
      List<ExpenseModel> eachDataExpense = [];
      num eachDateAmount = 0;
      for (ExpenseModel eachModel in arrExpense) {
        if (eachModel.expense_time.contains(eachExp)) {
          eachDataExpense.add(eachModel);
          if (eachModel.expense_type == 0) {
            //debit
            eachDateAmount = eachDateAmount - eachModel.expense_amt;
          } else {
            // credit
            eachDateAmount = eachDateAmount + eachModel.expense_amt;
          }
        }
        // print(eachDateAmount);
        // print(arrDateWiseExpense.length);
      }
      arrDateWiseExpense.add(FilteredExpenseModel(
          dateName: eachExp,
          eachDateAmt: eachDateAmount,
          arrExpenses: eachDataExpense));
      totalDateAmount = totalDateAmount + eachDateAmount;
    }
  }

  // for filtering a month wise data

  void filteringMonthWiseExpense(List<ExpenseModel> expenses) {
    arrMonthWiseExpense.clear();
    totalMonthAmount = 0;
    List<String> eachUniqueMonth = [];
    for (ExpenseModel model in expenses) {
      var eachMonth = DateTime.parse(model.expense_time);
      var month =
          "${eachMonth.year}-${eachMonth.month.toString().length < 2 ? "0${eachMonth.month}" : "${eachMonth.month}"}";

      if (!eachUniqueMonth.contains(month)) {
        eachUniqueMonth.add(month);
      }
    }

    // step 2;
    for (String uniqueMonths in eachUniqueMonth) {
      List<ExpenseModel> expenseModel = [];
      num eachMonthAmount = 0;
      for (ExpenseModel model in expenses) {
        if (model.expense_time.contains(uniqueMonths)) {
          expenseModel.add(model);
          if (model.expense_type == 0) {
            // debit
            eachMonthAmount = eachMonthAmount - model.expense_amt;
          } else {
            eachMonthAmount = eachMonthAmount + model.expense_amt;
          }
        }
      }
      arrMonthWiseExpense.add(FilteredExpenseModel(
          dateName: uniqueMonths,
          eachDateAmt: eachMonthAmount,
          arrExpenses: expenseModel));
      totalMonthAmount = totalMonthAmount + eachMonthAmount;
    }
  }

  void filteredExpenseByYear(List<ExpenseModel> arrExpense) {
    arrYearWiseExpense.clear();
    totalYearAmount = 0;
    List<String> eachUniqueYear = [];
    for (ExpenseModel expenseModel in arrExpense) {
      var year = DateTime.parse(expenseModel.expense_time);
      var mYear = "${year.year}";

      if (!eachUniqueYear.contains(mYear)) {
        eachUniqueYear.add(mYear);
      }
    }

    //step 2
    for (String uniqueYear in eachUniqueYear) {
      List<ExpenseModel> eachExpenseModel = [];
      num eachYearAmount = 0;
      for (ExpenseModel eachModel in arrExpense) {
        if (eachModel.expense_time.contains(uniqueYear)) {
          eachExpenseModel.add(eachModel);
          if (eachModel.expense_type == 0) {
            //debit
            eachYearAmount = eachYearAmount - eachModel.expense_amt;
          } else {
            eachYearAmount = eachYearAmount + eachModel.expense_amt;
          }
        }
      }
      arrYearWiseExpense.add(FilteredExpenseModel(
          dateName: uniqueYear,
          eachDateAmt: eachYearAmount,
          arrExpenses: eachExpenseModel));
      totalYearAmount = totalYearAmount + eachYearAmount;
    }
  }
}
