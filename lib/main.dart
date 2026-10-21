import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luckystone/appTheme/app_Theme.dart';
import 'package:luckystone/appTheme/theme_Cubit.dart';
import 'package:luckystone/appTheme/theme_State.dart';
import 'package:luckystone/checkNetwork/network_bloc.dart';
import 'package:luckystone/checkNetwork/network_event.dart';
import 'package:luckystone/extra/colors.dart';
import 'package:luckystone/extra/shared_preferences.dart';
import 'package:luckystone/extra/text_constants.dart';
import 'package:luckystone/routes/route_observer.dart';
import 'package:luckystone/routes/router.dart';
import 'package:luckystone/routes/routes_name.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'appTheme/theme_Prefrences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    systemNavigationBarColor: MyColor.primaryDark, // navigation bar color
    statusBarColor: MyColor.primaryDark, // status bar color
  ));
  await AppPreferences.shared.initialisePrefs();
  FluroRouters.setupRouter(FluroRouters.router);
  final themeRepository = ThemeRepository(
    sharedPreferences: await SharedPreferences.getInstance(),
  );

  runApp(
    BlocProvider<NetworkBloc>(
      create: (_) => NetworkBloc()..add(ListenConnection()),
      child: MyApp(themeRepository: themeRepository),
    ),
  );
}

class MyApp extends StatelessWidget {
  final ThemeRepository themeRepository;

  const MyApp({super.key, required this.themeRepository});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: themeRepository,
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => ThemeCubit(
              themeRepository: context.read<ThemeRepository>(),
            )..getCurrentTheme(),
          ),
          // atul asl add app-wide cubits here (e.g. CartCubit, WishlistCubit)
        ],
        child: const App(),
      ),
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      buildWhen: (previous, current) => previous.themeMode != current.themeMode,
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(FocusNode());
          },
          child: MaterialApp(
            navigatorObservers: [routeObserver],
            debugShowCheckedModeBanner: false,
            color: Colors.white,
            title: TextConstants.appName,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: state.themeMode,
            onGenerateRoute: FluroRouters.router.generator,
            initialRoute: RoutesName.splashScreen,
          ),
        );
      },
    );
  }
}
