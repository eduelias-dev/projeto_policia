import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'dart:io';
import 'cubit/ocorrencia_cubit.dart';
import 'pages/menu_page.dart';

void main() {
  // Configura o SQLite para Windows
  if (Platform.isWindows || Platform.isLinux) {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OcorrenciaCubit(),
      child: MaterialApp(
        title: 'Ocorrências Remotas',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 58, 183, 125),
          ),
          useMaterial3: true,
        ),
        home: const MenuPage(),
      ),
    );
  }
}
