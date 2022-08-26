import 'dart:async';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:todo_yandex/screens/tasks_page.dart';
import 'package:todo_yandex/view/main_page.dart';
import 'package:todo_yandex/view/task_adder.dart';
import 'package:todo_yandex/model/task.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_yandex/navigation/controller.dart';
import 'view/app_theme.dart';
import 'firebase_options.dart';
import 'navigation/routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

  await Hive.initFlutter();
  Hive.registerAdapter(TaskContainerAdapter());
  Hive.registerAdapter(TaskImportanceAdapter());
  await Hive.openLazyBox<TaskContainer>('box_for_tasks');
  await Hive.openLazyBox<Map<String, dynamic>>('box_queue_back');
  await Hive.openBox<int>('revision');

  runZonedGuarded<Future<void>>(() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    final remoteConfig = FirebaseRemoteConfig.instance;
    await remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: const Duration(minutes: 1),
      minimumFetchInterval: const Duration(hours: 1),
    ));
    await remoteConfig.fetchAndActivate();
    Themes.fetchImportantColor();

    runApp(const ProviderScope(child: ToDoApp()));
  },
      (error, stack) =>
          FirebaseCrashlytics.instance.recordError(error, stack, fatal: true));
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Done',
      theme: Themes.lightThemeData,
      darkTheme: Themes.darkThemeData,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('ru'),
      ],
      // navigatorKey: NavigationController().key,
      // routes: {
      //   Routes.main: (_) => const TasksPage(),
      //   Routes.editor: (_) =>
      //       TaskAdder(created: created, task: task, index: index),
      // },
      // initialRoute: 'Routes.main',
      home: const TasksPage2(),
    );
  }
}
