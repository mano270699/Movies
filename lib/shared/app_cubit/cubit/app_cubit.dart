import 'dart:async';
import 'dart:io' as Io;
import 'dart:io';
import 'package:image/image.dart' as Img;
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:meta/meta.dart';
import 'package:movies/models/movie_details.dart';
import 'package:movies/models/now_playing.dart';
import 'package:movies/models/populer.dart';
import 'package:movies/shared/components/constant.dart';
import 'package:movies/shared/network/end_point.dart';
import 'package:movies/shared/network/local/cache.dart';
import 'package:movies/shared/network/network/dio_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

import '../../../models/hive_nowplaying.dart';
import '../../../models/top_rated.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;
import 'package:path/path.dart' as path;
part 'app_state.dart';

class AppCubit extends Cubit<AppCubitState> {
  AppCubit() : super(AppCubitInitial());
  int currentNowPlayingPagenum = 1;
  int currentPopulerPagenum = 1;
  int currentTopRatedPagenum = 1;

  static AppCubit get(context) => BlocProvider.of(context);

  Populer? populersModel;
  List<Results> populerList = [];
  void getPopulerMovies(int pageNumper) {
    emit(AppCubitGetPopulerLoading());
    DioHelper.getData(
        path: POPULER,
        query: {'api_key': apiKey, 'page': pageNumper}).then((value) {
      populersModel = Populer.fromJson(value.data);
      populersModel!.results!.forEach((element) {
        populerList.add(element);
      });
      print(populersModel.toString());
      print(populersModel!.results![1].title.toString());

      emit(AppCubitGetPopulerScusses());
    }).catchError((error) {
      print(error.toString());
      emit(AppCubitGetPopulerError());
    });
  }

  List<Result> topRatedList = [];
  Top_Rated? topRatedModel;
  void getTopRatedMovies(int pageNumber) {
    // topRatedModel = null;
    emit(AppCubitGetTopRatedLoading());
    DioHelper.getData(
        path: TOPRATED,
        query: {'api_key': apiKey, 'page': pageNumber}).then((value) {
      topRatedModel = Top_Rated.fromJson(value.data);
      topRatedModel!.results!.forEach((element) {
        topRatedList.add(element);
      });
      print(topRatedModel.toString());
      print(topRatedModel!.results![1].title.toString());

      emit(AppCubitGetTopRatedScusses());
    }).catchError((error) {
      print(error.toString());
      emit(AppCubitGetTopRatedError());
    });
  }

  Future<String> createFolderInAppDocDir(String folderName) async {
    //Get this App Document Directory

    final Io.Directory? _appDocDir = await getExternalStorageDirectory();
    //App Document Directory + folder name
    final Directory _appDocDirFolder =
        Directory('${_appDocDir!.path}/$folderName/');

    if (await _appDocDirFolder.exists()) {
      //if folder already exists return path
      return _appDocDirFolder.path;
    } else {
      //if folder not exists create folder and then return its path
      final Directory _appDocDirNewFolder =
          await _appDocDirFolder.create(recursive: true);
      return _appDocDirNewFolder.path;
    }
  }

  Future<Io.File> saveImage(File file, String path) async {
    //retrieve local path for device
    Img.Image? image = Img.decodeImage(file.readAsBytesSync());
    // Image image = decodeImage(file.readAsBytesSync());

    Img.Image thumbnail = Img.copyResize(
      image!,
      height: 120,
    );

    // Save the thumbnail as a PNG.
    return new Io.File(path)..writeAsBytesSync(Img.encodePng(thumbnail));
  }

  NowPlaying? nowPlayingModel;
  List<ResultsNowPlaying> nowPlayingList = [];
  List<NowPayingHive> hiveNowPlaying = [];
  void getNowPlayingMovies(int pageNumber) {
    emit(AppCubitGetNowPlayingLoading());

    DioHelper.getData(
        path: NOWPLAYING,
        query: {'api_key': apiKey, 'page': pageNumber}).then((value) {
      nowPlayingModel = NowPlaying.fromJson(value.data);
      nowPlayingModel!.results!.forEach((element) async {
        final imageName = path.basename(element.backdropPath!);

        final localPath = path.join(
            await createFolderInAppDocDir('NowPlaying_Image'), imageName);

        // final imageFile = File(localPath);
        // await imageFile.writeAsBytes(value.data.bodyBytes);

        // print("localPath: $localPath");
        Cache.saveNowPlaying(new NowPayingHive(
          movieId: element.id,
          title: element.title,
          releaseDate: element.releaseDate,
          voteAverage: element.voteAverage,
          overview: element.overview,
          image: localPath,
        ));
        print("cacheing Data ${Cache.getNowPlaying()}");

        nowPlayingList.add(element);
        // Cache.getNowPlaying();
      });

      emit(AppCubitGetNowPlayingScusses());
    }).catchError((error) {
      print(error.toString());
      emit(AppCubitGetNowPlayingError());
    });
  }

  Future<bool> loadMoreNowPlaying() async {
    emit(AppCubitNowPlayingLoadMoreState());
    print('loadMoreNowPlaying');
    currentNowPlayingPagenum++;

    getNowPlayingMovies(currentNowPlayingPagenum);
    emit(AppCubitNowPlayingLoadMoreSucsessState());
    return true;
  }

  Future<bool> loadMorePopuler() async {
    emit(AppCubitPopulerLoadMoreState());
    print('loadMorePopuler');
    currentPopulerPagenum++;

    getPopulerMovies(currentPopulerPagenum);
    emit(AppCubitPopulerLoadMoreSucsessState());
    return true;
  }

  Future<bool> loadMoreTopRated() async {
    emit(AppCubitTopRatedLoadMoreState());
    print('loadMoreTopRated');
    currentTopRatedPagenum++;

    getTopRatedMovies(currentTopRatedPagenum);
    emit(AppCubitTopRatedLoadMoreSucsessState());
    return true;
  }

  MovieDetails? movieDitails;
  void getMovieDetails({required int movieID, int pageNum = 1}) {
    emit(AppCubitGetMovieDetailsLoading());
    DioHelper.getData(path: MOVIE + '/$movieID', query: {
      'api_key': apiKey,
    }).then((value) {
      movieDitails = MovieDetails.fromJson(value.data);
      //  print(movieDitails.toString());
      print(movieDitails!.overview);

      emit(AppCubitGetMovieDetailsScusses());
    }).catchError((error) {
      print(error.toString());
      emit(AppCubitGetMovieDetailsError());
    });
  }

  void reloadData() {
    getPopulerMovies(1);
    getNowPlayingMovies(1);
    getTopRatedMovies(1);
  }
}
