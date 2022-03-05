import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_conditional_rendering/conditional.dart';
import 'package:movies/models/now_playing.dart';
import 'package:movies/shared/app_cubit/cubit/app_cubit.dart';
import 'package:movies/shared/components/components.dart';
import 'package:movies/shared/network/local/cache.dart';
import 'package:movies/shared/styels/icon_broken.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../models/hive_nowplaying.dart';
import 'movie_details_screen.dart';

// ignore: must_be_immutable
class NowPlayingScreen extends StatefulWidget {
  NowPlayingScreen({
    Key? key,
    required this.connected,
  }) : super(key: key);
  final bool connected;

  @override
  _NowPlayingScreenState createState() => _NowPlayingScreenState();
}

class _NowPlayingScreenState extends State<NowPlayingScreen> {
  var scrollController = ScrollController();
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  NowPayingHive? nowplayingh;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppCubitState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        if (widget.connected) {
          return RefreshConfiguration(
              footerTriggerDistance: 15,
              dragSpeedRatio: 0.91,
              headerBuilder: () => MaterialClassicHeader(
                    color: Colors.blue,
                  ),
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
                  conditionBuilder: (context) =>
                      AppCubit.get(context).nowPlayingList.length > 0,
                  widgetBuilder: (context) => SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: true,
                        header: WaterDropHeader(),
                        controller: _refreshController,
                        onRefresh: () {
                          // ConnectionStatusSingleton connectionStatus =
                          //     ConnectionStatusSingleton.getInstance();
                          // _connectionChangeStream = connectionStatus
                          //     .connectionChange
                          //     .listen(connectionChanged);
                          cubit.nowPlayingList = [];
                          AppCubit.get(context).reloadData();
                        },
                        onLoading: () {
                          print('onLoading');
                          setState(() {
                            AppCubit.get(context)..loadMoreNowPlaying();
                            Future.delayed(Duration(seconds: 2));
                            _refreshController.loadComplete();
                          });
                        },
                        child: ListView.separated(
                            controller: scrollController,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              //check connection

                              return buildMovieItem(
                                context,
                                cubit.nowPlayingList,
                                index,
                                cubit,
                              );
                            },
                            separatorBuilder: (context, index) => SizedBox(
                                  height: 0,
                                ),
                            itemCount: cubit.nowPlayingList.length),
                      ),
                  fallbackBuilder: (context) {
                    return Container();
                  }));
        } else {
          Cache.getNowPlaying();
          print(Cache.nowHiveList.length);
          return ListView.separated(
              controller: scrollController,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                //check connection

                // Cache.getNowPlaying();

                return FutureBuilder(
                    future: Cache.getNowPlaying(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return buildMovieItemCached(
                            context, Cache.nowHiveList, index, cubit);
                      } else {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.blue),
                        );
                      }
                    });
              },
              separatorBuilder: (context, index) => SizedBox(
                    height: 0,
                  ),
              itemCount: Cache.nowHiveList.length);
        }
      },
    );
  }

  Widget buildNoInternetWidget() {
    return Center(
      child: Container(
        color: Colors.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 20,
            ),
            Text(
              'Can\'t connect.. Check Internet!',
              style: TextStyle(
                color: Colors.black,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Image.asset('assets/images/nointernet.png'),
          ],
        ),
      ),
    );
  }

  Widget buildMovieItem(
    BuildContext context,
    List<ResultsNowPlaying> populer,
    int index,
    AppCubit cubit,
  ) =>
      Container(
        padding: EdgeInsetsDirectional.only(start: 5, end: 5),
        height: 400,
        width: double.infinity,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
        child: InkWell(
          onTap: () {
            navigateTo(
                context,
                DetailsScreen(
                  movieId: populer[index].id,
                ));
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image(
                  height: 250,
                  fit: BoxFit.cover,
                  image: NetworkImage(
                    '${populer[index].backdropPath}',
                  ),
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

Widget buildMovieItemCached(
  BuildContext context,
  List<NowPayingHive> nowPayingHive,
  int index,
  AppCubit cubit,
) =>
    Container(
      padding: EdgeInsetsDirectional.only(start: 5, end: 5),
      height: 400,
      width: double.infinity,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(6)),
      child: InkWell(
        onTap: () {
          // navigateTo(
          //     context,
          //     DetailsScreen(
          //       movieId: "${nowPayingHive[index].movieId}",
          //     ));
        },
        child: Card(
          clipBehavior: Clip.antiAliasWithSaveLayer,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image(
                height: 250,
                fit: BoxFit.cover,
                image:
                    //Image.file(new File("${nowPayingHive[index].image}")).image,
                    FileImage(File("${nowPayingHive[index].image}")),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    start: 10, end: 10, top: 5, bottom: 5),
                child: Text(
                  "${nowPayingHive[index].title}",
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
                    Text("${nowPayingHive[index].releaseDate}",
                        style: TextStyle(
                            fontFamily: 'Jannah', color: Colors.indigoAccent)),
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
                        Text('${nowPayingHive[index].voteAverage}',
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
                  '${nowPayingHive[index].overview}',
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
