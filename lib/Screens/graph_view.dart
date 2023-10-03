import 'package:expense_app2/Routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../Bloc/expense_bloc.dart';
import '../Models/expense_model.dart';
import '../Models/filtered_expense_model.dart';
import '../constants/app_constants.dart';

class GraphView extends StatefulWidget {
  const GraphView({super.key});

  static List<FilteredExpenseModel> arrDateWiseExpense = [];
  static List<FilteredExpenseModel> arrMonthWiseExpense = [];
  static List<FilteredExpenseModel> arrYearWiseExpense = [];
  static num totalDateAmount = 0;
  static num totalMonthAmount = 0;
  static num totalYearAmount = 0;
  static num maxAmount = 0;

  @override
  State<GraphView> createState() => _GraphViewState();
}

class _GraphViewState extends State<GraphView> {
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
                                  "\$${GraphView.totalDateAmount}",
                                  textScaleFactor: 1.5,
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: GraphView.arrDateWiseExpense.length,
                              itemBuilder: (context, index) {
                                final data =
                                    GraphView.arrDateWiseExpense[index];
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
    GraphView.totalDateAmount = 0;
    GraphView.arrDateWiseExpense.clear();
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
      GraphView.arrDateWiseExpense.add(FilteredExpenseModel(
          dateName: eachExp,
          eachDateAmt: eachDateAmount,
          arrExpenses: eachDataExpense));
      GraphView.totalDateAmount = GraphView.totalDateAmount + eachDateAmount;
    }
  }

  void filteredExpenseByYear(List<ExpenseModel> arrExpense) {
    GraphView.arrYearWiseExpense.clear();
    GraphView.totalYearAmount = 0;
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
      GraphView.arrYearWiseExpense.add(FilteredExpenseModel(
          dateName: uniqueYear,
          eachDateAmt: eachYearAmount,
          arrExpenses: eachExpenseModel));
      GraphView.totalYearAmount = GraphView.totalYearAmount + eachYearAmount;
    }
  }
}
