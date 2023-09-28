import 'dart:io';
import 'package:expense_app2/Models/expense_model.dart';
import 'package:expense_app2/sharedpreference/local_storage.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../Models/usermodel.dart';

class AppDataBase {
  AppDataBase._();

  static final AppDataBase db = AppDataBase._();
  static final USER_TABLE = "user";
  static final USER_COLUMN_ID = "u_id";
  static final USER_COLUMN_EMAIL = "email";
  static final USER_COLUMN_PASSWORD = "password";
  static final USER_COLUMN_CONFIRM_PASSWORD = "confirmPassword";
  static final USER_MOBILE_NO = "mobileNo";

  // expense varibles;
  static const String EXPENSE_TABLE = "expense";
  static const String EXPENSE_COLUMN_ID = "exp_id";
  static const String EXPENSE_COLUMN_TITLE = "exp_title";
  static const String EXPENSE_COLUMN_DESC = "exp_desc";
  static const String EXPENSE_COLUMN_amt = "exp_amt";
  static const String EXPENSE_COLUMN_BAL = "exp_bal";
  static const String EXPENSE_COLUMN_TYPE =
      "exp_type"; // 0 FOR DEBIT AND 1 FOR CREDIT
  static const String EXPENSE_COLUMN_CAT_ID = "exp_cat_id";
  static const String EXPENSE_COLUMN_TIME = "exp_time";

  Database? _database;

  Future<Database> getDB() async {
    if (_database != null) {
      return _database!;
    } else {
      return await initDB();
    }
  }

  Future<Database> initDB() async {
    Directory directoryDocuments = await getApplicationDocumentsDirectory();
    var dbPath = join(directoryDocuments.path, "expenseDB.DB");
    return openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        db.execute(
            "Create table $USER_TABLE ( $USER_COLUMN_ID integer primary key autoincrement, $USER_COLUMN_EMAIL text unique, $USER_COLUMN_PASSWORD text, $USER_COLUMN_CONFIRM_PASSWORD text, $USER_MOBILE_NO text )");
        db.execute(
            "Create table $EXPENSE_TABLE ( $EXPENSE_COLUMN_ID integer primary key autoincrement, $USER_COLUMN_ID integer, $EXPENSE_COLUMN_TITLE text, $EXPENSE_COLUMN_DESC text, $EXPENSE_COLUMN_BAL real, $EXPENSE_COLUMN_CAT_ID integer, $EXPENSE_COLUMN_TYPE integer, $EXPENSE_COLUMN_TIME String, $EXPENSE_COLUMN_amt integer )");
      },
    );
  }

  Future<bool> createAccount(UserModel model) async {
    bool check = await checkEmailAlreadyExist(model);
    var db = await getDB();
    if (check) {
      print("check = $check");
      return false;
    } else {
      print("tttttt");
      var count = await db.insert(USER_TABLE, model.toMap());
      return count > 0;
    }
  }

  Future<bool> checkEmailAlreadyExist(UserModel model) async {
    var db = await getDB();
    List<Map<String, dynamic>> data = await db.query(USER_TABLE);
    List<UserModel> modelList = [];
    for (Map<String, dynamic> map in data) {
      modelList.add(UserModel.fromMap(map));
    }
    return modelList.isNotEmpty;
  }

  Future<bool> authenticateUser(String email, String password) async {
    var db = await getDB();
    List<Map<String, dynamic>> count = await db.query(USER_TABLE,
        where: "$USER_COLUMN_EMAIL = ? and $USER_COLUMN_PASSWORD = ?",
        whereArgs: [email, password]);

    if (count.isNotEmpty) {
      var prefs = await Shared.getPrefs();
      prefs.setInt(Shared().userId, int.parse(count[0][USER_COLUMN_ID].toString()));
    }

    return count.isNotEmpty;
  }

// expense method

  Future<bool> addExpense(ExpenseModel model) async {
    var db = await getDB();
    var data = await db.insert(EXPENSE_TABLE, model.toMap());
    return data > 0;
  }

  Future<List<ExpenseModel>> fetchAllExpenseByUser() async {
    var db = await getDB();
    var prefs = await Shared.getPrefs();
    int? uid = prefs.getInt(Shared().userId);
    List<Map<String, dynamic>> mapNotes = await db
        .query(EXPENSE_TABLE, where: "$USER_COLUMN_ID = ?", whereArgs: [uid]);

    List<ExpenseModel> expenseList = [];
    for (Map<String, dynamic> mapData in mapNotes) {
      expenseList.add(ExpenseModel.fromMap(mapData));
    }
    return expenseList;
  }
}
