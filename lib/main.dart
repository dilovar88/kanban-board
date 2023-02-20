import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kanban_board/bloc/task/task_bloc.dart';
import 'package:kanban_board/helpers/local_storage.dart';
import 'package:kanban_board/pages/tasks/tasks_page.dart';
import 'package:kanban_board/helpers/locator.dart';

void main() async {
  setup();

  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await LocalStorage().init();

  runApp(EasyLocalization(
      supportedLocales: const [
        Locale('en', 'US'),
        Locale('ru', 'RU')
      ],
      // useOnlyLangCode: true,
      path: 'assets/translations',
      fallbackLocale: const Locale('en', 'US'),
      child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Intl.defaultLocale = context.locale.languageCode;

    return MaterialApp(
      locale: context.locale,
      supportedLocales: context.supportedLocales,
      localizationsDelegates: context.localizationDelegates,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // home: ExportCSV(),
      home:  BlocProvider(create: (_) => TaskBloc(), child: const TaskPage()),
      // debugShowCheckedModeBanner: false,
    );
  }
}
