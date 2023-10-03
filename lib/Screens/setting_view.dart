import 'package:expense_app2/Bloc/expense_bloc.dart';
import 'package:expense_app2/Models/filtered_expense_model.dart';
import 'package:expense_app2/Screens/graph_view.dart';
import 'package:expense_app2/constants/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            body: ListView(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 25),
      children: [
        Center(
          child: Text(
            "\$${GraphView.totalDateAmount.abs()}",
            textScaleFactor: 1.5,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        BlocBuilder<ExpenseBloc, ExpenseState>(
          builder: (context, state) {
            if (state is ExpenseLoadingState) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is ExpenseErrorState) {
              return Center(
                child: Text(state.errorMessage),
              );
            } else if (state is ExpenseLoadedState) {
              AppConstants.filteringMonthWiseExpense(state.listExpense);
              return Column(
                children: [
                  SizedBox(
                    height: 300,
                    child: SfCartesianChart(
                        tooltipBehavior: TooltipBehavior(enable: true),
                        borderColor: Colors.black,
                        borderWidth: 2,
                        legend: Legend(isVisible: true),
                        primaryXAxis: CategoryAxis(),
                        primaryYAxis: NumericAxis(
                            // axisLine: AxisLine(),
                            rangePadding: ChartRangePadding.round,
                            minimum: 0,
                            maximum: GraphView.maxAmount.toDouble(),
                            interval: 1000),
                        series: <LineSeries<FilteredExpenseModel, String>>[
                          LineSeries<FilteredExpenseModel, String>(
                              dataSource: GraphView.arrMonthWiseExpense,
                              xValueMapper: (FilteredExpenseModel data, _) {
                                return data.dateName;
                              },
                              yValueMapper: (FilteredExpenseModel data, _) =>
                                  data.eachDateAmt.toDouble(),
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelPosition:
                                      ChartDataLabelPosition.inside)),
                          LineSeries<FilteredExpenseModel, String>(
                              dataSource: GraphView.arrMonthWiseExpense,
                              xValueMapper: (FilteredExpenseModel data, _) {
                                return data.dateName;
                              },
                              yValueMapper: (FilteredExpenseModel data, _) =>
                                  data.eachDateAmt.toDouble(),
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,
                                  labelPosition:
                                      ChartDataLabelPosition.inside)),
                        ],
                        title: ChartTitle(
                            text: "Expenses",
                            textStyle: TextStyle(fontWeight: FontWeight.bold))),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          "Month",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: Text(
                          "year",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        child: Text(
                          "Week",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        style: TextButton.styleFrom(
                            elevation: 5,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                      ),
                    ],
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: GraphView.arrMonthWiseExpense.length,
                    itemBuilder: (context, index) {
                      final varData = GraphView.arrMonthWiseExpense[index];
                      return Column(
                        children: [
                          ListView.builder(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: varData.arrExpenses.length,
                            itemBuilder: (context, childIndex) {
                              final secondData =
                                  varData.arrExpenses[childIndex];
                              var imagePath = AppConstants.categories
                                  .firstWhere((element) =>
                                      element["id"] ==
                                      secondData.expense_cat_id)["img"];
                              return ListTile(
                                leading: Image.asset(imagePath),
                                subtitle: Text(secondData.expenseDesc),
                                title: Text(secondData.expenseTitle),
                                trailing: Text(
                                  secondData.expense_amt.toString(),
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textScaleFactor: 1.3,
                                ),
                              );
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ],
              );
            }
            return Container();
          },
        )
      ],
    )));
  }
}
