import 'package:hive/hive.dart';
part 'hive_nowplaying.g.dart';

@HiveType(typeId: 0)
class NowPayingHive {
  @HiveField(0)
  int? movieId;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? image;
  @HiveField(3)
  String? releaseDate;
  @HiveField(4)
  num? voteAverage;
  @HiveField(5)
  String? overview;
  NowPayingHive({
    this.movieId,
    this.title,
    this.image,
    this.releaseDate,
    this.voteAverage,
    this.overview,
  });
}
