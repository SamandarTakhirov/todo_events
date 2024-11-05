import 'package:calendar/router/app_routes.dart';
import 'package:calendar/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'features/bloc/main_bloc.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MainBloc(DatabaseService.instance),
      child: MaterialApp.router(
        title: "ToDo Events",
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    );
  }
}
