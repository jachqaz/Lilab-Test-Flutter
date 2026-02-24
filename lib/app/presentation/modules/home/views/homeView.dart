import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';

import '../../cubits.dart';
import '../controller/homeController.dart';
import '../state/homeState.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => HomeController(HomeState())..init(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          actions: [],
        ),
        body: BlocBuilder<HomeCubit, Object>(
          builder: (context, state) => SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) => RefreshIndicator(
                onRefresh: context.read<HomeController>().init,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: SizedBox(
                    height: constraints.maxHeight,
                    child: const Column(children: [Text("HomeView")]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
