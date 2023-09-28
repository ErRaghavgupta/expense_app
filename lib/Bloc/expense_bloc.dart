import 'package:bloc/bloc.dart';
import 'package:expense_app2/Models/expense_model.dart';
import 'package:meta/meta.dart';
import '../Database/Appdatabase.dart';

part 'expense_event.dart';

part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  AppDataBase db;

  ExpenseBloc({required this.db}) : super(ExpenseInitial()) {
    on<AddExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());
      bool check = await db.addExpense(event.model);
      if (check) {
        var data = await db.fetchAllExpenseByUser();
        emit(ExpenseLoadedState(listExpense: data));
      } else {
        emit(ExpenseErrorState(errorMessage: "Data not Added!!"));
      }
    });

    //
    on<FetchExpenseEvent>((event, emit) async {
      emit(ExpenseLoadingState());
      var data = await db.fetchAllExpenseByUser();
      emit(ExpenseLoadedState(listExpense: data));
    });
  }
}
