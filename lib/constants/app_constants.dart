import 'package:expense_app2/constants/ImageConstants.dart';

import '../Models/expense_model.dart';
import '../Models/filtered_expense_model.dart';
import '../Screens/graph_view.dart';

class AppConstants {
  static const List<Map<String, dynamic>> categories = [
    {"id": 1, "name": "travel", "img": ImageConstants.travelImage},
    {"id": 2, "name": "coffee", "img": ImageConstants.coffeeImage},
    {"id": 3, "name": "fastFood", "img": ImageConstants.fastFoodImage},
    {"id": 4, "name": "giftBox", "img": ImageConstants.giftBoxImage},
    {"id": 5, "name": "hotPot", "img": ImageConstants.hotPotImage},
    {"id": 6, "name": "music", "img": ImageConstants.musicImage},
    {"id": 7, "name": "popcorn", "img": ImageConstants.popcornImage},
    {"id": 8, "name": "restaurant", "img": ImageConstants.restaurantImage},
    {"id": 9, "name": "shopping", "img": ImageConstants.bagImage},
    {"id": 10, "name": "snack", "img": ImageConstants.snackImage},
    {"id": 11, "name": "tools", "img": ImageConstants.toolsImage},
    {"id": 12, "name": "vegetables", "img": ImageConstants.vegetablesImage},
  ];

  static void filteringMonthWiseExpense(List<ExpenseModel> expenses) {
    GraphView.arrMonthWiseExpense.clear();
    GraphView.totalMonthAmount = 0;
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
      if (eachMonthAmount > GraphView.maxAmount) {
        GraphView.maxAmount = eachMonthAmount;
      }
      GraphView.arrMonthWiseExpense.add(FilteredExpenseModel(
          dateName: uniqueMonths,
          eachDateAmt: eachMonthAmount,
          arrExpenses: expenseModel));
      GraphView.totalMonthAmount = GraphView.totalMonthAmount + eachMonthAmount;
    }
  }
}
