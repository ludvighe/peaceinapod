import 'dart:async';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:just_audio_background/just_audio_background.dart';
import 'package:peaceinapod/podcastindex/models/episode.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AudioPlayerProvider extends ChangeNotifier {
  Episode? _episode;
  bool playing = false;
  bool loading = false;

  AudioPlayer player = AudioPlayer();

  Timer? playingListener;

  AudioPlayerProvider() {
    player.playerStateStream.listen((state) {
      playing = state.playing;
      notifyListeners();
    });
  }

  Future<void> playEpisode(Episode value) async {
    bool shouldLoadUrl = value.id != _episode?.id;

    loading = true;
    _episode = value;
    notifyListeners();

    int initialPosition = 0;
    if (shouldLoadUrl) {
      var prefs = await SharedPreferences.getInstance();
      var previousPosition = prefs.getInt("${value.id}.episode_position");
      if (previousPosition != null) initialPosition = previousPosition;
      // await player.setUrl(value.enclosureUrl);
      await player.setAudioSource(AudioSource.uri(
        Uri.parse(value.enclosureUrl),
        tag: MediaItem(
          id: '${value.id}',
          album: "",
          title: value.title,
          artUri: Uri.parse(value.image),
        ),
      ));
      await player.seek(Duration(milliseconds: initialPosition));
    }

    player.play();

    playingListener?.cancel();
    playingListener = Timer.periodic(const Duration(seconds: 3), (timer) async {
      var prefs = await SharedPreferences.getInstance();
      prefs.setInt(
        "${value.id}.episode_position",
        player.position.inMilliseconds,
      );
    });

    playing = true;
    loading = false;
    notifyListeners();

    // player.playerStateStream.listen((event) {if (event)})
  }

  Future<void> paus() async {
    await player.pause();
    playing = false;

    playingListener?.cancel();
    notifyListeners();
  }

  Episode? get episode => _episode;
}
