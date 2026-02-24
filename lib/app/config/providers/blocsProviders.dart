import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../presentation/modules/home/controller/homeController.dart';
import '../../presentation/modules/home/cubit/homeCubit.dart';
import '../../presentation/modules/home/state/homeState.dart';
import '../../presentation/myApp.dart';
import '../router/routerSimpleCubit.dart';

class BlocsProviders extends StatelessWidget {
  const BlocsProviders({super.key});

  @override
  Widget build(BuildContext context) {
    List<SingleChildWidget> providers = [];
    providers.addAll(buildBlocProvider);
    providers.addAll(buildChangeNotifierProvider);
    return MultiBlocProvider(providers: providers, child: const MyApp());
  }

  List<SingleChildWidget> get buildBlocProvider {
    return [
      BlocProvider(
        create: (context) =>
            RouterSimpleCubit(context.watch<RouterSimpleCubit>().state),
      ),
      BlocProvider(create: (context) => HomeCubit(HomeState())),
    ];
  }

  List<SingleChildWidget> get buildChangeNotifierProvider {
    return [
      ChangeNotifierProvider<HomeController>(
        create: (context) => HomeController(HomeState()),
      ),
    ];
  }
}
