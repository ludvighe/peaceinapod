import 'package:peaceinapod/podcastindex/api.dart';

class PIndexTest {
  String token = "3F3B2TYBKKDXXUCWJJF8";
  String secret = r"jdQVShqgNcsPcuJn9buqqJLbN7d$s$c$5aP5^kTp";
  Future run() async {
    testSearch();
  }

  Future testSearch() async {
    var api = PIndex(token, secret);
    var result = await api.searchPodcastByTerm("Fråga Anders och Måns");
    // var result = await api.searchByTitle("Fråga Anders och Måns");
  }
}
