import 'package:expense_app2/Database/Appdatabase.dart';

class ExpenseModel {
  int? expId;
  String expenseTitle;
  String expenseDesc;
  num expenseBal;
  int expense_cat_id;
  int expense_type;
  String expense_time;
  int u_id;
  int expense_amt;

  ExpenseModel(
      {required this.u_id,
      required this.expenseTitle,
      required this.expenseDesc,
      required this.expense_cat_id,
      required this.expense_time,
      required this.expense_type,
      required this.expenseBal,
      required this.expense_amt,
      this.expId});

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
        u_id: map[AppDataBase.USER_COLUMN_ID],
        expenseTitle: map[AppDataBase.EXPENSE_COLUMN_TITLE],
        expenseDesc: map[AppDataBase.EXPENSE_COLUMN_DESC],
        expense_cat_id: map[AppDataBase.EXPENSE_COLUMN_CAT_ID],
        expense_time: map[AppDataBase.EXPENSE_COLUMN_TIME],
        expense_type: map[AppDataBase.EXPENSE_COLUMN_TYPE],
        expenseBal: map[AppDataBase.EXPENSE_COLUMN_BAL],
        expense_amt: map[AppDataBase.EXPENSE_COLUMN_amt]);
  }

  Map<String, dynamic> toMap() {
    return {
      AppDataBase.USER_COLUMN_ID: u_id,
      AppDataBase.EXPENSE_COLUMN_amt: expense_amt,
      AppDataBase.EXPENSE_COLUMN_BAL: expenseBal,
      AppDataBase.EXPENSE_COLUMN_TYPE: expense_type,
      AppDataBase.EXPENSE_COLUMN_TIME: expense_time,
      AppDataBase.EXPENSE_COLUMN_TITLE: expenseTitle,
      AppDataBase.EXPENSE_COLUMN_DESC: expenseDesc,
      AppDataBase.EXPENSE_COLUMN_ID: expId,
      AppDataBase.EXPENSE_COLUMN_CAT_ID: expense_cat_id,
    };
  }
}
