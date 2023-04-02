import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peaceinapod/constants/colors.dart';
import 'package:peaceinapod/podcastindex/models/episode.dart';
import 'package:peaceinapod/podcastindex/models/podcast.dart';
import 'package:peaceinapod/providers/audioplayer.provider.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastEpisodesWidget extends StatelessWidget {
  final Podcast podcast;
  const PodcastEpisodesWidget(this.podcast, {super.key});

  @override
  Widget build(BuildContext context) => Consumer<PIndexProvider>(
        builder: (context, provider, child) {
          List<Episode> episodes = provider.episodes
              .where((element) => element.feedId == podcast.id)
              .toList();
          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Icon(Icons.arrow_back),
                      const SizedBox(
                        width: 24,
                      ),
                      Expanded(
                        child: Text(
                          podcast.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                // if (provider.loading) const LinearProgressIndicator(),
                const SizedBox(height: 12.0),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await provider.searchEpisodes(podcast);
                    },
                    child: ListView(
                      children: episodes.isEmpty
                          ? [const Center(child: Text("No episodes loaded"))]
                          : episodes
                              .map((episode) => Container(
                                  color:
                                      provider.episodes.indexOf(episode) % 2 ==
                                              0
                                          ? null
                                          : Colors.white.withOpacity(0.02),
                                  child: _EpisodeRow(episode)))
                              .toList(),
                    ),
                  ),
                )
              ],
            ),
          );
        },
      );
}

class _EpisodeRow extends StatefulWidget {
  final Episode episode;

  const _EpisodeRow(this.episode);

  @override
  State<_EpisodeRow> createState() => _EpisodeRowState();
}

class _EpisodeRowState extends State<_EpisodeRow> {
  final secondaryTextStyle = const TextStyle(color: Colors.grey);
  bool complete = false;
  double previousPosition = 0;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance()
        .then((prefs) => prefs.getInt("${widget.episode.id}.episode_position"))
        .then((value) {
      if (value == null) {
        return;
      }
      // Calculate previous position
      double valueLength = value / 1000;
      double expectedLength = max(
        widget.episode.duration.toDouble(),
        valueLength,
      );
      setState(() {
        previousPosition = valueLength / expectedLength;
        if (valueLength >= expectedLength * .98) complete = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AudioPlayerProvider>(
      builder: (context, provider, child) {
        bool isCurrent = provider.episode?.id == widget.episode.id;
        return InkWell(
          onTap: () {
            if (isCurrent && provider.playing) {
              provider.paus();
            } else {
              provider.playEpisode(widget.episode);
            }
          },
          child: Container(
            padding: const EdgeInsets.fromLTRB(30, 10, 30, 10),
            child: Opacity(
              opacity: complete ? 0.4 : 1,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.episode.datePublishedPretty,
                        style: secondaryTextStyle,
                      ),
                      Text(
                        widget.episode.episode == null
                            ? ""
                            : "${widget.episode.episode}",
                        style: secondaryTextStyle,
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          widget.episode.title,
                          style: Theme.of(context).textTheme.bodyLarge,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                      Icon(
                        isCurrent && provider.playing
                            ? Icons.pause_circle
                            : Icons.play_circle,
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: provider.loading && isCurrent
                        ? const LinearProgressIndicator()
                        : isCurrent
                            ? StreamBuilder(
                                stream: provider.player.positionStream,
                                builder: (BuildContext context,
                                    AsyncSnapshot<Duration> snapshot) {
                                  double position = 0;
                                  if (snapshot.data != null &&
                                      provider.player.duration != null) {
                                    position = snapshot.data!.inMilliseconds /
                                        provider
                                            .player.duration!.inMilliseconds;
                                  }

                                  return LinearProgressIndicator(
                                    value: position,
                                  );
                                },
                              )
                            : LinearProgressIndicator(
                                value: previousPosition,
                                color: Colors.black.withOpacity(0.3),
                                backgroundColor: Colors.black.withOpacity(0.2),
                              ),
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
