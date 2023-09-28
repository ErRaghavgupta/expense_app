part of 'expense_bloc.dart';

@immutable
abstract class ExpenseState {}

class ExpenseInitial extends ExpenseState {}

class ExpenseLoadingState extends ExpenseState {}

class ExpenseLoadedState extends ExpenseState {
  List<ExpenseModel> listExpense;

  ExpenseLoadedState({required this.listExpense});
}

class ExpenseErrorState extends ExpenseState {
  String errorMessage;

  ExpenseErrorState({required this.errorMessage});
}
