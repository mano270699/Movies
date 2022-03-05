class Populer {
  num? page;
  List<Results>? results;
  num? totalResults;
  num? totalPages;

  Populer(
      {required this.page,
      required this.results,
      required this.totalResults,
      required this.totalPages});

  Populer.fromJson(Map<String, dynamic> json) {
    page = json['page'];
    if (json['results'] != null) {
      results = <Results>[];
      json['results'].forEach((v) {
        results!.add(new Results.fromJson(v));
      });
    }
    totalResults = json['total_results'];
    totalPages = json['total_pages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['page'] = this.page;
    if (this.results != null) {
      data['results'] = this.results!.map((v) => v.toJson()).toList();
    }
    data['total_results'] = this.totalResults;
    data['total_pages'] = this.totalPages;
    return data;
  }
}

class Results {
  String imagePath = 'https://www.themoviedb.org/t/p/w220_and_h330_face';
  String? posterPath;
  bool? adult;
  String? overview;
  String? releaseDate;
  List<num>? genreIds;
  num? id;
  String? originalTitle;
  String? originalLanguage;
  String? title;
  String? backdropPath;
  num? popularity;
  num? voteCount;
  bool? video;
  num? voteAverage;

  Results(
      {required this.posterPath,
      required this.adult,
      required this.overview,
      required this.releaseDate,
      required this.genreIds,
      required this.id,
      required this.originalTitle,
      required this.originalLanguage,
      required this.title,
      required this.backdropPath,
      required this.popularity,
      required this.voteCount,
      required this.video,
      required this.voteAverage});

  Results.fromJson(Map<String, dynamic> json) {
    posterPath = imagePath + json['poster_path'];
    adult = json['adult'];
    overview = json['overview'];
    releaseDate = json['release_date'];
    if (json['genre_ids'] != null) {
      genreIds = <num>[];
      json['genre_ids'].forEach((v) {
        genreIds!.add(v);
      });
    }

    id = json['id'];
    originalTitle = json['original_title'];
    originalLanguage = json['original_language'];
    title = json['title'];
    backdropPath = imagePath + json['backdrop_path'];
    popularity = json['popularity'];
    voteCount = json['vote_count'];
    video = json['video'];
    voteAverage = json['vote_average'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['poster_path'] = this.posterPath;
    data['adult'] = this.adult;
    data['overview'] = this.overview;
    data['release_date'] = this.releaseDate;
    data['genre_ids'] = this.genreIds;
    data['id'] = this.id;
    data['original_title'] = this.originalTitle;
    data['original_language'] = this.originalLanguage;
    data['title'] = this.title;
    data['backdrop_path'] = this.backdropPath;
    data['popularity'] = this.popularity;
    data['vote_count'] = this.voteCount;
    data['video'] = this.video;
    data['vote_average'] = this.voteAverage;
    return data;
  }
}
