import 'package:expense_app2/Bloc/expense_bloc.dart';
import 'package:expense_app2/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Models/expense_model.dart';
import '../Models/filtered_expense_model.dart';

class ShowExpenseView extends StatefulWidget {
  const ShowExpenseView({super.key});

  @override
  State<ShowExpenseView> createState() => _ShowExpenseViewState();
}

class _ShowExpenseViewState extends State<ShowExpenseView> {
  @override
  void initState() {
    super.initState();
    context.read<ExpenseBloc>().add(FetchExpenseEvent());
  }

  List<FilteredExpenseModel> arrDateWiseExpense = [];
  List<FilteredExpenseModel> arrMonthWiseExpense = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            filteringMonthWiseExpense(state.listExpense);
            return ListView(
              children: [
                Text("Month Wise Expense"),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: arrDateWiseExpense.length,
                  itemBuilder: (context, index) {
                    final data = arrDateWiseExpense[index];
                    return Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(data.dateName),
                            Text(data.eachDateAmt.toString()),
                          ],
                        ),
                        Divider(
                          color: Colors.black,
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: data.arrExpenses.length,
                          itemBuilder: (context, childIndex) {
                            final currItems = data.arrExpenses[childIndex];
                            var imagePath = AppConstants.categories.firstWhere(
                                (element) =>
                                    element["id"] ==
                                    currItems.expense_cat_id)["img"];
                            return ListTile(
                              leading: Image.asset(imagePath),
                              title: Text(currItems.expenseTitle),
                              subtitle: Text(currItems.expenseDesc),
                              trailing: Text(currItems.expense_amt.toString()),
                            );
                          },
                        )
                      ],
                    );
                  },
                ),
              ],
            );
          }
          return Container();
        },
      ),
    );
  }

  // for filtering a data with date wise

  void filteringExpenseByDate(List<ExpenseModel> arrExpense) {
    arrDateWiseExpense.clear();
    List<String> eachUniqueDates = [];
    for (ExpenseModel eachExp in arrExpense) {
      var eachDate = DateTime.parse(eachExp.expense_time);
      var mDate =
          "${eachDate.year}-${eachDate.month.toString().length < 2 ? "0${eachDate.month}" : "${eachDate.month}"}-${eachDate.day}";

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

        arrDateWiseExpense.add(FilteredExpenseModel(
            dateName: eachExp,
            eachDateAmt: eachDateAmount,
            arrExpenses: eachDataExpense));
        // print(arrDateWiseExpense.length);
      }
    }
  }

  // for filtering a month wise data

  void filteringMonthWiseExpense(List<ExpenseModel> expenses) {
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
    }
  }
}
