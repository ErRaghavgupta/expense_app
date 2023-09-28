import 'expense_model.dart';

class FilteredExpenseModel {
  String dateName;
  num eachDateAmt;
  List<ExpenseModel> arrExpenses;

  FilteredExpenseModel(
      {required this.dateName,
      required this.eachDateAmt,
      required this.arrExpenses});
}
