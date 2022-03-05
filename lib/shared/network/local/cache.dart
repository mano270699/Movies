import 'package:hive/hive.dart';
import '../../../models/hive_nowplaying.dart';

class Cache {
  static Future<void> saveNowPlaying(nowPayingHive) async {
    var box = Hive.box('movie');
    box.put("nowplaying", nowPayingHive);

    //box.close();
  }

  static List<NowPayingHive> nowHiveList = [];
  static Future<List<NowPayingHive>> getNowPlaying() async {
    var box = Hive.box("movie");
    NowPayingHive? nowplying = box.get('nowplaying');
    // print("boxlength: ${box.length}");

    nowHiveList.add(NowPayingHive(
        image: nowplying!.image,
        movieId: nowplying.movieId,
        overview: nowplying.overview,
        title: nowplying.title,
        releaseDate: nowplying.releaseDate,
        voteAverage: nowplying.voteAverage));

    // print("image: ${nowplying!.image}");
    // print("title:${nowplying.title}");
    // print("nowHiveListLenght:${nowHiveList.length}");
    //box.close();
    return nowHiveList;
  }
}
