import 'dart:convert';
import 'dart:developer';

import 'package:crypto/crypto.dart';
import 'package:http/http.dart' as http;
import 'package:peaceinapod/podcastindex/models/episode.dart';

import 'models/podcast.dart';

class PIndex {
  PIndex(this.token, this.secret);

  String authority = "api.podcastindex.org";
  String baseUrl = "api/1.0/";
  String userAgent = "PeaceInAPod/1.0";
  String token;
  String secret;

  Map<String, String> _generateHeaders() {
    var timestamp = DateTime.now().millisecondsSinceEpoch / 1000;
    var time = timestamp.toString().split(".")[0];
    var hash = sha1.convert(utf8.encode("$token$secret$time")).toString();
    return {
      "User-Agent": userAgent,
      "X-Auth-Key": token,
      "X-Auth-Date": time,
      "Authorization": hash,
    };
  }

  Future<Map<String, dynamic>> _get(
      String path, Map<String, dynamic> params) async {
    var uri = Uri.https('api.podcastindex.org', "api/1.0/$path", params);
    var headers = _generateHeaders();
    var response = await http.get(uri, headers: headers);
    return jsonDecode(response.body);
  }

  /// This call returns all of the feeds that match the search terms in the title, author or owner of the feed.
  Future<List<Podcast>> searchPodcastByTerm(String term) async {
    var data = await _get("/search/byterm", {"q": term});
    var podcasts =
        (data["feeds"] as List).map((feed) => Podcast.fromJson(feed)).toList();
    return podcasts;
  }

  /// This call returns all of the feeds where the title of the feed matches the search term (ignores case).
  ///
  /// Example "everything everywhere daily" will match the podcast Everything Everywhere Daily by "everything everywhere" will not.
  Future<List<Podcast>> searchPodcastByTitle(String title) async {
    var data = await _get("/search/bytitle", {"q": title});
    var podcasts =
        (data["feeds"] as List).map((feed) => Podcast.fromJson(feed)).toList();
    return podcasts;
  }

  /// This call returns all of the feeds that match the search terms in the title, author or owner of the feed.
  Future<List<Episode>> searchEpisodeByPerson(String name) async {
    var data = await _get("/search/byperson", {"q": name});
    var episodes = (data["items"] as List)
        .map((episode) => Episode.fromJson(episode))
        .toList();
    return episodes;
  }

  Future<Podcast> getPodcastById(int id) async {
    var data = await _get("/podcasts/byfeedid", {"id": id.toString()});
    var podcast = Podcast.fromJson(data["feed"]);
    return podcast;
  }

  Future<Podcast> getPodcastByFeedUrl(String url) async {
    var data = await _get("/podcasts/byfeedurl", {"url": url});
    var podcast = Podcast.fromJson(data["feed"]);
    return podcast;
  }

  Future<List<Episode>> getEpisodesByFeedId(int id) async {
    var data = await _get(
        "/episodes/byfeedid", {"id": id.toString(), "max": 1000.toString()});
    var episodes = (data["items"] as List)
        .map((episode) => Episode.fromJson(episode))
        .toList();
    return episodes;
  }
}
