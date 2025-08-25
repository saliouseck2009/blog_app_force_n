import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/blog/presentation/bloc/blog_bloc.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'core/auth_wrapper.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialisation de l'injection de dépendances
  await di.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            loginUseCase: di.sl(),
            signUpUseCase: di.sl(),
            getCurrentUserUseCase: di.sl(),
            authRepository: di.sl(),
          )..add(const CheckAuthStatusEvent()),
        ),
        BlocProvider(create: (context) => di.sl<BlogBloc>()),
      ],
      child: MaterialApp(
        title: 'Blog App - Clean Architecture Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const AuthWrapper(),
      ),
    );
  }
}
