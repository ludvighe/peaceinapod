import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:peaceinapod/podcastindex/api.dart';
import 'package:peaceinapod/podcastindex/models/episode.dart';
import 'package:peaceinapod/podcastindex/models/podcast.dart';
import 'package:peaceinapod/secrets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PIndexProvider extends ChangeNotifier {
  late String _key = podcastIndexKey;
  late String _secret = podcastIndexSecret;

  bool loading = false;
  DateTime? latestRefresh;

  List<Podcast> podcasts = [];
  final String _podcastsString = "podcasts";

  List<Episode> episodes = [];
  final String _episodesString = "episodes";

  List<Podcast> podcastSearch = [];
  final String _podcastSearchString = "podcastSearch";

  Future<void> init() async {
    var prefs = await SharedPreferences.getInstance();

    // Fetch podcasts from shared preferences
    String? podcastsPrefs = prefs.getString(_podcastsString);
    if (podcastsPrefs != null) {
      List decodedPodcastsPrefs = jsonDecode(podcastsPrefs);
      podcasts =
          decodedPodcastsPrefs.map((json) => Podcast.fromJson(json)).toList();
    }
    // Fetch episodes from shared preferences
    String? episodesPrefs = prefs.getString(_episodesString);
    if (episodesPrefs != null) {
      List decodedEpisodesPrefs = jsonDecode(episodesPrefs);
      episodes =
          decodedEpisodesPrefs.map((json) => Episode.fromJson(json)).toList();
    }

    // Fetch podcastSearch from shared preferences
    String? podcastSearchPrefs = prefs.getString(_podcastSearchString);
    if (podcastSearchPrefs != null) {
      List decodedPodcastSearchPrefs = jsonDecode(podcastSearchPrefs);
      podcastSearch = decodedPodcastSearchPrefs
          .map((json) => Podcast.fromJson(json))
          .toList();
    }

    notifyListeners();
  }

  void login(String key, String secret) {
    _key = key;
    _secret = secret;
    init();
  }

  void searchPodcast(String term) async {
    loading = true;
    notifyListeners();
    var resPodcasts = await PIndex(_key, _secret).searchPodcastByTerm(term);
    var prefs = await SharedPreferences.getInstance();

    var serializedPodcastSearch = jsonEncode(
      resPodcasts.map((podcast) => podcast.toMap()).toList(),
    );
    prefs.setString(_podcastSearchString, serializedPodcastSearch);
    podcastSearch = resPodcasts;
    loading = false;
    notifyListeners();
  }

  Future<void> searchEpisodes(Podcast podcast) async {
    loading = true;
    notifyListeners();
    var resEpisodes =
        await PIndex(_key, _secret).getEpisodesByFeedId(podcast.id);
    var prefs = await SharedPreferences.getInstance();
    for (var episode in resEpisodes) {
      episodes.removeWhere((element) => element.id == episode.id);
      episodes.add(episode);
    }
    var serializedEpisodes = jsonEncode(
      episodes.map((podcast) => podcast.toMap()).toList(),
    );
    prefs.setString(_episodesString, serializedEpisodes);
    loading = false;
    notifyListeners();
  }

  Future<void> subscribe(Podcast podcast) async {
    podcasts.add(podcast);
    var prefs = await SharedPreferences.getInstance();
    var serializedPodcasts = jsonEncode(
      podcasts.map((podcast) => podcast.toMap()).toList(),
    );
    prefs.setString(_podcastsString, serializedPodcasts);
    searchEpisodes(podcast);
    notifyListeners();
  }

  Future<void> unSubscribe(Podcast podcast) async {
    podcasts = podcasts.where((element) => element.id != podcast.id).toList();
    var prefs = await SharedPreferences.getInstance();
    var serializedPodcasts = jsonEncode(
      podcasts.map((podcast) => podcast.toMap()).toList(),
    );
    prefs.setString(_podcastsString, serializedPodcasts);
    notifyListeners();
  }

  Future<void> refreshPodcast(Podcast podcast) async {
    var resPodcasts =
        await PIndex(_key, _secret).searchPodcastByTitle(podcast.title);
    Podcast resPodcast = resPodcasts.where((e) => e.id == podcast.id).first;
    int index = podcasts.indexWhere((e) => e.id == podcast.id);
    podcasts[index] = resPodcast;
    notifyListeners();
  }

  Future<void> refreshPodcasts() async {
    List<Future<void>> requests = [];
    for (Podcast podcast in podcasts) {
      requests = [
        ...requests,
        refreshPodcast(podcast),
        searchEpisodes(podcast)
      ];
    }
    await Future.wait(requests);
    latestRefresh = DateTime.now();
    notifyListeners();
  }
}
