part of 'expense_bloc.dart';

@immutable
abstract class ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent {
  ExpenseModel model;

  AddExpenseEvent({required this.model});
}

class FetchExpenseEvent extends ExpenseEvent {}
