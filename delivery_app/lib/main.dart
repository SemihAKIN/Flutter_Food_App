import 'package:delivery_app/ui/cubit/favories_cubit.dart';
import 'package:delivery_app/ui/cubit/mainpage_cubit.dart';
import 'package:delivery_app/ui/cubit/menu_detail_cubit.dart';
import 'package:delivery_app/ui/cubit/sepet_sayfa_cubit.dart';
import 'package:delivery_app/ui/views/mainpage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AnasayfaCubit()),
        BlocProvider(create: (context) => DetaySayfaCubit()),
        BlocProvider(create: (context) => SepetSayfaCubit()),
        BlocProvider(create: (context) => FavSayfaCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MainPage(),
      ),
    );
  }
}
