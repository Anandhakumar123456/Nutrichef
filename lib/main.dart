import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:recipe/bloc/auth/auth_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipe/bloc/theme/theme_bloc.dart';
import 'package:recipe/firebase_options.dart';
import 'package:recipe/utils/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AuthBloc()),
        BlocProvider(create: (context) => ThemeBloc()),
      ],
      child: MaterialApp(
        initialRoute: '/',
        routes: routes(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
