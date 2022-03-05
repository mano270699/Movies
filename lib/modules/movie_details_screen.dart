import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:movies/models/movie_details.dart';
import 'package:movies/shared/app_cubit/cubit/app_cubit.dart';

class DetailsScreen extends StatelessWidget {
  final movieId;

  DetailsScreen({
    Key? key,
    required this.movieId,
  }) : super(key: key);
  Widget buildSilverAppBar({required String name, required String image}) {
    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      stretch: true,
      centerTitle: true,
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.blue,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          '$name',
          style: TextStyle(
              color: Colors.white, fontFamily: 'Jannah', fontSize: 15),
        ),
        background: Hero(
          tag: 'posterImage',
          child: image.isNotEmpty
              ? FadeInImage.assetNetwork(
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: 'assets/images/loading.gif',
                  image: image,
                  fit: BoxFit.cover,
                )
              : Image(
                  image: AssetImage('assets/images/placeholder.gif'),
                ),
        ),
      ),
    );
  }

  Widget buildCharacterDetails(MovieDetails movieDetails) {
    return CustomScrollView(
      slivers: [
        buildSilverAppBar(
            name: movieDetails.title!,
            image: movieDetails.imagePath + movieDetails.posterPath!),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              Container(
                margin: EdgeInsets.fromLTRB(14, 14, 14, 0),
                padding: EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent[100],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Popularty: ${movieDetails.popularity}',
                              style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Jannah",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Vote: ${movieDetails.voteAverage}',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.red[400],
                                fontFamily: "Jannah",
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    Text(
                      '${movieDetails.overview}',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Jannah',
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(
                      height: 300,
                    )
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
  }

  showLoadingIndecator() {
    return Center(
      child: CircularProgressIndicator(color: Colors.blue),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AppCubit()..getMovieDetails(movieID: movieId),
      child: BlocConsumer<AppCubit, AppCubitState>(
        listener: (context, state) {
          if (state is AppCubitGetMovieDetailsLoading) {
            return showLoadingIndecator();
          }
        },
        builder: (context, state) {
          var cubit = AppCubit.get(context);

          return Scaffold(
            body: Conditional.single(
                context: context,
                conditionBuilder: (BuildContext context) {
                  return cubit.movieDitails != null;
                },
                widgetBuilder: (BuildContext context) {
                  return buildCharacterDetails(cubit.movieDitails!);
                },
                fallbackBuilder: (BuildContext context) {
                  return showLoadingIndecator();
                }),
          );
        },
      ),
    );
  }
}
