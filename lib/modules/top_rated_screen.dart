import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:movies/models/populer.dart';
import 'package:movies/shared/app_cubit/cubit/app_cubit.dart';
import 'package:movies/shared/components/components.dart';
import 'package:movies/shared/styels/icon_broken.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/top_rated.dart';
import 'movie_details_screen.dart';

class TopRatedScreen extends StatefulWidget {
  const TopRatedScreen({Key? key}) : super(key: key);

  @override
  _TopRatedScreenState createState() => _TopRatedScreenState();
}

class _TopRatedScreenState extends State<TopRatedScreen> {
  var scrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitState>(
        listener: (context, state) {},
        builder: (context, state) {
          var cubit = AppCubit.get(context);
          // var path = 'https://www.themoviedb.org/t/p/w220_and_h330_face';
          return RefreshConfiguration(
            footerTriggerDistance: 15,
            dragSpeedRatio: 0.91,
            headerBuilder: () => MaterialClassicHeader(),
            footerBuilder: () => ClassicFooter(),
            enableLoadingWhenNoData: false,
            enableRefreshVibrate: false,
            enableLoadMoreVibrate: false,
            shouldFooterFollowWhenNotFull: (state) {
              // If you want load more with noMoreData state ,may be you should return false
              return false;
            },
            child: Conditional.single(
                context: context,
                conditionBuilder: (context) => cubit.topRatedList.length > 0,
                widgetBuilder: (context) => SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: true,
                      header: WaterDropHeader(),
                      controller: _refreshController,
                      onRefresh: () {
                        cubit.topRatedList = [];
                        AppCubit.get(context).getTopRatedMovies(1);
                      },
                      onLoading: () {
                        print('onLoading');
                        setState(() {
                          AppCubit.get(context)..loadMoreTopRated();
                          Future.delayed(Duration(seconds: 2));
                          _refreshController.loadComplete();
                        });
                      },
                      child: ListView.separated(
                          controller: scrollController,
                          physics: BouncingScrollPhysics(),
                          itemBuilder: (context, index) {
                            return buildMovieItem(
                              cubit.topRatedList,
                              index,
                            );
                          },
                          separatorBuilder: (context, index) => SizedBox(
                                height: 0,
                              ),
                          itemCount: cubit.topRatedList.length),
                    ),
                fallbackBuilder: (context) => Center(
                      child: CircularProgressIndicator(
                        color: Colors.blue,
                      ),
                    )),
          );
        });
  }

  Widget buildMovieItem(
    List<Result> populer,
    int index,
  ) =>
      Container(
        padding: EdgeInsetsDirectional.only(start: 5, end: 5),
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: InkWell(
          onTap: (() {
            navigateTo(
                context,
                DetailsScreen(
                  movieId: populer[index].id,
                ));
          }),
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  height: 250,
                  fit: BoxFit.cover,
                  image: NetworkImage("${populer[index].imagePath}" +
                      '${populer[index].backdropPath}'),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      start: 10, end: 10, top: 5, bottom: 5),
                  child: Text(
                    '${populer[index].title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Jannah',
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                    start: 10,
                    end: 10,
                  ),
                  child: Row(
                    children: [
                      Text('${populer[index].releaseDate}',
                          style: TextStyle(
                              fontFamily: 'Jannah',
                              color: Colors.indigoAccent)),
                      Spacer(),
                      Row(
                        children: [
                          Icon(
                            IconBroken.Heart,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text('${populer[index].voteAverage}',
                              style: TextStyle(
                                  fontFamily: 'Jannah', color: Colors.blue))
                        ],
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(start: 10),
                  child: Text(
                    '${populer[index].overview}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.grey,
                      height: 1.2,
                      fontFamily: 'Jannah',
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}
