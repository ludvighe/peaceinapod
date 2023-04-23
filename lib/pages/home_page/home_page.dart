import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:peaceinapod/constants/colors.dart';
import 'package:peaceinapod/pages/home_page/search_widget.dart';
import 'package:peaceinapod/podcastindex/models/podcast.dart';
import 'package:peaceinapod/providers/audioplayer.provider.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:peaceinapod/providers/settings.provider.dart';
import 'package:peaceinapod/widgets/image.dart';
import 'package:peaceinapod/widgets/podcast_card.dart';
import 'package:peaceinapod/widgets/podcast_details_widget.dart';
import 'package:peaceinapod/widgets/podcast_episodes_widget.dart';
import 'package:provider/provider.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double _panelHeightOpen = 0;
  double _panelHeightClosed = 100.0;
  double _panelOpenPercentage = 0;
  final BorderRadius _panelBorderRadius = const BorderRadius.only(
    topLeft: Radius.circular(18.0),
    topRight: Radius.circular(18.0),
  );

  late Widget _currentBody;
  bool _popBack = true;

  @override
  void initState() {
    super.initState();
    _currentBody = _podcastsWidget();
  }

  @override
  Widget build(BuildContext context) {
    _panelHeightOpen = MediaQuery.of(context).size.height * .5;
    var episodeSet = Provider.of<AudioPlayerProvider>(context).episode != null;
    if (!episodeSet) {
      _panelHeightClosed = 0;
    } else {
      _panelHeightClosed = 90;
    }

    return WillPopScope(
      onWillPop: () async {
        if (_popBack) {
          return true;
        }
        setState(() {
          _popBack = true;
          _currentBody = _podcastsWidget();
        });
        return false;
      },
      child: Material(
        child: Stack(
          children: [
            SlidingUpPanel(
              maxHeight: _panelHeightOpen,
              minHeight: _panelHeightClosed,
              parallaxEnabled: true,
              parallaxOffset: .5,
              panel: _playerPanelWidget(),
              body: _currentBody,
              borderRadius: _panelBorderRadius,
              onPanelSlide: (position) {
                setState(() {
                  _panelOpenPercentage = position;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _podcastsWidget() {
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
          title: Row(
            children: const [
              // Provider.of<AudioPlayerProvider>(context).playing
              //     ? Image.asset(
              //         "assets/peaceinapod-l-pea.png",
              //         width: 25,
              //         height: 25,
              //       )
              //     : Image.asset(
              //         "assets/peaceinapod-r-pea.png",
              //         width: 25,
              //         height: 25,
              //       ),
              // const SizedBox(width: 12),
              Text("Podcasts"),
            ],
          ),
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
                                  onTap: () {
                                    setState(() {
                                      _popBack = false;
                                      _currentBody = _episodesWidget(podcast);
                                    });
                                  },
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

  Widget _episodesWidget(Podcast podcast) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => PodcastDetailsWidget(podcast),
                );
              },
              icon: const Icon(Icons.info))
        ],
        title: Text(podcast.title),
      ),
      body: PodcastEpisodesWidget(podcast),
    );
  }

  Widget _playerPanelWidget() {
    return Consumer<SettingsProvider>(
      builder: (context, settings, child) => Consumer<AudioPlayerProvider>(
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
                            _episodeImage(playerProvider),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                children: [
                                  Text(
                                    playerProvider.episode!.title,
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                  const SizedBox(height: 5),
                                  StreamBuilder(
                                    stream:
                                        playerProvider.player.positionStream,
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
                            AnimatedRotation(
                              turns: _panelOpenPercentage,
                              duration: const Duration(milliseconds: 20),
                              child: AnimatedOpacity(
                                opacity: 1 - _panelOpenPercentage,
                                duration: const Duration(milliseconds: 20),
                                child: _playPauseButton(playerProvider),
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

                        // Player controls
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            IconButton(
                              onPressed: () {
                                int newPosition =
                                    playerProvider.player.position.inSeconds -
                                        settings.rewind;

                                playerProvider.player.seek(
                                  Duration(seconds: newPosition),
                                );
                              },
                              icon: const Icon(
                                Icons.fast_rewind,
                                size: 50,
                              ),
                            ),
                            _playPauseButton(playerProvider),
                            IconButton(
                              onPressed: () {
                                int newPosition =
                                    playerProvider.player.position.inSeconds +
                                        settings.rewind;
                                playerProvider.player.seek(
                                  Duration(seconds: newPosition),
                                );
                              },
                              icon: const Icon(
                                Icons.fast_forward,
                                size: 50,
                              ),
                            ),
                          ],
                        ),

                        // Player slider
                        StreamBuilder(
                          stream: playerProvider.player.positionStream,
                          builder: (BuildContext context,
                              AsyncSnapshot<Duration> snapshot) {
                            double position = 0;
                            double value = 0;
                            double max = 1;

                            if (snapshot.data != null &&
                                playerProvider.player.duration != null) {
                              max = playerProvider
                                  .player.duration!.inMilliseconds
                                  .toDouble();
                              value = snapshot.data!.inMilliseconds.toDouble();
                              position = snapshot.data!.inMilliseconds /
                                  playerProvider
                                      .player.duration!.inMilliseconds;
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
                                playerProvider.player.seek(
                                    Duration(milliseconds: value.toInt()));
                              },
                              value: value,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
      ),
    );
  }

  IconButton _playPauseButton(AudioPlayerProvider playerProvider) {
    return IconButton(
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
        playerProvider.playing ? Icons.pause_circle : Icons.play_circle,
        size: 50,
      ),
    );
  }

  ClipRRect _episodeImage(AudioPlayerProvider playerProvider) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(18.0),
      ),
      child: PodNetworkImage(
        url: playerProvider.episode!.image,
        height: 70,
        width: 70,
        errorWidget: CachedNetworkImage(
          imageUrl: playerProvider.episode!.feedImage,
          height: 70,
          width: 70,
          errorWidget: (context, url, error) => const Icon(
            Icons.podcasts,
            size: 60,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
