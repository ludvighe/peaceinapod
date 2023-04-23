import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peaceinapod/podcastindex/models/episode.dart';
import 'package:peaceinapod/podcastindex/models/podcast.dart';
import 'package:peaceinapod/providers/audioplayer.provider.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PodcastEpisodesWidget extends StatefulWidget {
  final Podcast podcast;
  const PodcastEpisodesWidget(this.podcast, {super.key});

  @override
  State<PodcastEpisodesWidget> createState() => _PodcastEpisodesWidgetState();
}

class _PodcastEpisodesWidgetState extends State<PodcastEpisodesWidget> {
  late TextEditingController _searchController;
  bool _sortDate = true;

  bool _searchFilter(Episode episode) {
    if (_searchController.text == "") return true;
    String lowerTitle = episode.title.toLowerCase();
    return lowerTitle.contains(_searchController.text.toLowerCase());
  }

  int _dateSort(Episode a, Episode b) {
    if (_sortDate) {
      return a.datePublished < b.datePublished ? 1 : -1;
    }
    return a.datePublished > b.datePublished ? 1 : -1;
  }

  @override
  void initState() {
    _searchController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Consumer<PIndexProvider>(
        builder: (context, provider, child) {
          List<Episode> episodes = provider.episodes
              .where((element) => element.feedId == widget.podcast.id)
              .where(_searchFilter)
              .toList()
            ..sort(_dateSort);

          return Card(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        style: const TextStyle(fontSize: 12),
                        controller: _searchController,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {
                          setState(() {});
                        },
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _sortDate = !_sortDate;
                          });
                        },
                        icon: const Icon(Icons.sort))
                  ],
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: () async {
                      await provider.searchEpisodes(widget.podcast);
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
