
import '../Database/Appdatabase.dart';

class UserModel {
  int? id;
  String email;
  String password;
  String confirmPassword;
  String mobileNo;

  UserModel(
      {this.id,
      required this.email,
      required this.password,
      required this.confirmPassword,
      required this.mobileNo});

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
        email: map[AppDataBase.USER_COLUMN_EMAIL],
        password: map[AppDataBase.USER_COLUMN_PASSWORD],
        confirmPassword: map[AppDataBase.USER_COLUMN_CONFIRM_PASSWORD],
        mobileNo: map[AppDataBase.USER_MOBILE_NO],
        id: map[AppDataBase.USER_COLUMN_ID]);
  }

  Map<String, dynamic> toMap() {
    return {
      AppDataBase.USER_COLUMN_ID: id,
      AppDataBase.USER_COLUMN_EMAIL: email,
      AppDataBase.USER_COLUMN_PASSWORD: password,
      AppDataBase.USER_COLUMN_CONFIRM_PASSWORD: confirmPassword,
      AppDataBase.USER_MOBILE_NO: mobileNo,
    };
  }
}
