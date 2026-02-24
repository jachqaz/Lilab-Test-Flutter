import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class RouterSimpleCubit extends Cubit<GoRouter> {
  RouterSimpleCubit(GoRouter goRouter) : super(goRouter);

  void goBack() {
    state.pop();
  }

  void goHome() {
    state.go('/');
  }
}
