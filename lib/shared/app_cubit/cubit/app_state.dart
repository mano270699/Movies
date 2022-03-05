part of 'app_cubit.dart';

@immutable
abstract class AppCubitState {}

class AppCubitInitial extends AppCubitState {}

class AppCubitGetPopulerLoading extends AppCubitState {}

class AppCubitGetPopulerScusses extends AppCubitState {}

class AppCubitGetPopulerError extends AppCubitState {}

class AppCubitGetTopRatedLoading extends AppCubitState {}

class AppCubitGetTopRatedScusses extends AppCubitState {}

class AppCubitGetTopRatedError extends AppCubitState {}

class AppCubitGetNowPlayingLoading extends AppCubitState {}

class AppCubitGetNowPlayingScusses extends AppCubitState {}

class AppCubitGetNowPlayingError extends AppCubitState {}

class AppCubitGetMovieDetailsLoading extends AppCubitState {}

class AppCubitGetMovieDetailsScusses extends AppCubitState {}

class AppCubitGetMovieDetailsError extends AppCubitState {}

class AppCubitNowPlayingLoadMoreState extends AppCubitState {}

class AppCubitPopulerLoadMoreState extends AppCubitState {}

class AppCubitTopRatedLoadMoreState extends AppCubitState {}

class AppCubitNowPlayingLoadMoreSucsessState extends AppCubitState {}

class AppCubitPopulerLoadMoreSucsessState extends AppCubitState {}

class AppCubitTopRatedLoadMoreSucsessState extends AppCubitState {}

class NowPlayingCreateDatabaseState extends AppCubitState {}

class NowPlayingInsertDatabaseState extends AppCubitState {}

class NowPlayingGetDatabaseLoadingState extends AppCubitState {}

class NowPlayingGetDatabaseState extends AppCubitState {}
