import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaceinapod/constants/colors.dart';
import 'package:peaceinapod/pages/home_page/search_widget.dart';
import 'package:peaceinapod/providers/audioplayer.provider.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:peaceinapod/widgets/podcast_card.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:yaru/yaru.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 100.0;
  final BorderRadius _panelBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(18.0),
    topRight: Radius.circular(18.0),
  );

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .5;
    var episodeSet = Provider.of<AudioPlayerProvider>(context).episode != null;
    if (!episodeSet) {
      _panelHeightClosed = 0;
    } else {
      _panelHeightClosed = 90;
    }

    return Material(
      child: Stack(
        children: [
          SlidingUpPanel(
            maxHeight: _panelHeightOpen,
            minHeight: _panelHeightClosed,
            parallaxEnabled: true,
            parallaxOffset: .5,
            panel: _playerPanelWidget(),
            body: _homePage(),
            borderRadius: _panelBorderRadius,
          ),
        ],
      ),
    );
  }

  Consumer<PIndexProvider> _homePage() {
    return Consumer<PIndexProvider>(
      builder: (context, provider, child) => Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => SearchWidget(),
                  );
                },
                icon: const Icon(Icons.search))
          ],
          title: const Text("Peaceinapod"),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: provider.podcasts.isEmpty
                  ? const Center(child: Text("You have no saved podcasts yet."))
                  : RefreshIndicator(
                      onRefresh: () async {
                        await provider.refreshPodcasts();
                      },
                      child: ListView(
                        children: provider.podcasts
                            .map((podcast) => PodcastCard(
                                  provider,
                                  podcast,
                                  mode: PodcastCardMode.preferEpisodes,
                                ))
                            .toList(),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Consumer<AudioPlayerProvider> _playerPanelWidget() {
    return Consumer<AudioPlayerProvider>(
      builder: (BuildContext context, playerProvider, Widget? child) =>
          playerProvider.episode == null
              ? Container(color: Theme.of(context).primaryColor)
              : Container(
                  height: 80,
                  padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                  decoration: BoxDecoration(
                    borderRadius: _panelBorderRadius,
                    gradient: LinearGradient(
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                      colors: [
                        piapGreen,
                        piapGreenDark,
                      ],
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(18.0),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: playerProvider.episode!.image,
                              height: 70,
                              width: 70,
                              errorWidget: (context, url, error) => const Icon(
                                Icons.podcasts,
                                size: 60,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  playerProvider.episode!.title,
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                                const SizedBox(height: 5),
                                StreamBuilder(
                                  stream: playerProvider.player.positionStream,
                                  builder: (BuildContext context,
                                      AsyncSnapshot<Duration> snapshot) {
                                    return Text(
                                      "${snapshot.data.toString().split('.')[0]} / "
                                      "${playerProvider.player.duration.toString().split('.')[0]}",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.7),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () {
                              if (playerProvider.playing) {
                                playerProvider.paus();
                              } else {
                                playerProvider.playEpisode(
                                  playerProvider.episode!,
                                );
                              }
                            },
                            icon: Icon(
                              playerProvider.playing
                                  ? Icons.pause_circle
                                  : Icons.play_circle,
                              size: 50,
                            ),
                          )
                        ],
                      ),
                      Expanded(
                        child: ListView(
                          children: [
                            Text(playerProvider.episode!.description
                                .replaceAll(RegExp(r"<br( |)/>"), "\n")
                                .replaceAll(RegExp(r"<(/|)(p|b)( |)>"), "")),
                            Text(
                              "Released: ${playerProvider.episode!.datePublishedPretty}",
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            onPressed: () {
                              var curr =
                                  playerProvider.player.position.inMilliseconds;
                              var delta = 10000;
                              playerProvider.player
                                  .seek(Duration(milliseconds: curr - delta));
                            },
                            icon: const Icon(
                              Icons.fast_rewind,
                              size: 50,
                            ),
                          ),
                          Image.asset(
                            "assets/peaceinapod.png",
                            width: 50,
                          ),
                          IconButton(
                            onPressed: () {
                              var curr =
                                  playerProvider.player.position.inMilliseconds;
                              var delta = 10000;
                              playerProvider.player
                                  .seek(Duration(milliseconds: curr + delta));
                            },
                            icon: const Icon(
                              Icons.fast_forward,
                              size: 50,
                            ),
                          ),
                        ],
                      ),
                      StreamBuilder(
                        stream: playerProvider.player.positionStream,
                        builder: (BuildContext context,
                            AsyncSnapshot<Duration> snapshot) {
                          double position = 0;
                          double value = 0;
                          double max = 1;

                          if (snapshot.data != null &&
                              playerProvider.player.duration != null) {
                            max = playerProvider.player.duration!.inMilliseconds
                                .toDouble();
                            value = snapshot.data!.inMilliseconds.toDouble();
                            position = snapshot.data!.inMilliseconds /
                                playerProvider.player.duration!.inMilliseconds;
                          }
                          if (value > max) {
                            value = max;
                          }
                          return Slider(
                            thumbColor: piapGreen,
                            activeColor: piapGreen,
                            inactiveColor: piapGreenDark,
                            max: max.toDouble(),
                            min: 0,
                            onChanged: (double value) {
                              playerProvider.player
                                  .seek(Duration(milliseconds: value.toInt()));
                            },
                            value: value,
                          );
                        },
                      ),
                    ],
                  ),
                ),
    );
  }
}
