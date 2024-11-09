import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:new_app/screens/add_time_sheet_screen.dart';
import 'package:new_app/services/api_services.dart';
import "package:sizer/sizer.dart";

import 'bloc/cubit.dart';

void main() async {
  await ApiServices.getAuthToken();
  runApp(MultiBlocProvider(providers: [
    BlocProvider(
        create: (_) => AppCubit(),
    )
  ], child: const MyApp(),));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, screentype) {
        return const GetMaterialApp(
          debugShowCheckedModeBanner: false,
          home: AddTimeSheetScreen(),
        );
      },
    );
  }
}

