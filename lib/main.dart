import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:movies/models/hive_nowplaying.dart';
import 'package:movies/modules/home_page.dart';
import 'package:movies/shared/app_cubit/cubit/app_cubit.dart';
import 'package:movies/shared/bloc_observer.dart';
import 'package:movies/shared/network/network/dio_helper.dart';
import 'package:splash_screen_view/SplashScreenView.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Hive.registerAdapter(NowPayingHiveAdapter());
  await Hive.initFlutter();
  await Hive.openBox("movie");

  DioHelper.init();

  Bloc.observer = MyBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()
        ..getPopulerMovies(1)
        ..getTopRatedMovies(1)
        ..getNowPlayingMovies(1),
      child: BlocConsumer<AppCubit, AppCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          return MaterialApp(
            title: 'Flutter Demo',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: SplashScreenView(
              navigateRoute: HomeScreen(),
              duration: 10000,
              imageSize: 350,
              imageSrc: "assets/images/logo.gif",
              // text: "Movies 🎞",
              // textType: TextType.ColorizeAnimationText,
              // textStyle: TextStyle(
              //   fontSize: 40.0,
              // ),
              // colors: [
              //   Color(0xFF552D24),
              //   Color(0xFF1D215B),
              //   Color(0xFF9A4E0A),
              //   Color(0xFF423843),
              //   Color(0xFF085191),
              //   Color(0xFFCD6604),
              // ],
              backgroundColor: Color(0xFFf7f7f7),
            ),
          );
        },
      ),
    );
  }
}
