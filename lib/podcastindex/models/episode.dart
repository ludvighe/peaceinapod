class Episode {
  ///
  /// The internal PodcastIndex.org episode ID.
  ///
  int id;

  ///
  /// Name of the feed
  ///
  String title;

  ///
  /// The channel-level link in the feed
  ///
  String link;

  ///
  /// The item-level description of the episode.
  ///
  /// Uses the longer of the possible fields in the feed: <description>, <itunes:summary> and <content:encoded>
  ///
  String description;

  ///
  /// The unique identifier for the episode
  ///
  String guid;

  ///
  /// The date and time the episode was published
  ///
  int datePublished;

  ///
  /// The date and time the episode was published formatted as a human readable string.
  ///
  /// Note: uses the PodcastIndex server local time to do conversion.
  ///
  String datePublishedPretty;

  ///
  /// The time this episode was found in the feed
  ///
  int dateCrawled;

  ///
  /// URL/link to the episode file
  ///
  String enclosureUrl;

  ///
  /// The Content-Type for the item specified by the enclosureUrl
  ///
  String enclosureType;

  ///
  /// The length of the item specified by the enclosureUrl in bytes
  ///
  int enclosureLength;

  ///
  /// The estimated length of the item specified by the enclosureUrl in seconds
  ///
  int duration;

  ///
  /// Is feed or episode marked as explicit
  ///
  /// 0: not marked explicit
  /// 1: marked explicit
  /// Allowed: 0┃1
  int explicit;

  ///
  /// Episode number
  ///
  int? episode;

  ///
  /// The type of episode
  ///
  /// Allowed: full┃trailer┃bonus
  String? episodeType;

  ///
  /// Season number
  ///
  int season;

  ///
  /// The item-level image for the episode
  ///
  String image;

  ///
  /// The iTunes ID of this feed if there is one, and we know what it is.
  ///
  int? feedItunesId;

  ///
  /// The channel-level image element.
  ///
  String feedImage;

  ///
  /// The internal PodcastIndex.org Feed ID.
  ///
  int feedId;

  ///
  /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec.
  ///
  String feedLanguage;

  ///
  /// At some point, we give up trying to process a feed and mark it as dead. This is usually after 1000 errors without a successful pull/parse cycle. Once the feed is marked dead, we only check it once per month.
  ///
  int feedDead;

  ///
  /// The internal PodcastIndex.org Feed ID this feed duplicates
  ///
  int? feedDuplicateOf;

  ///
  /// Link to the JSON file containing the episode chapters
  ///
  String? chaptersUrl;

  ///
  /// Link to the file containing the episode transcript
  ///
  String? transcriptUrl;

  ///
  /// List of transcripts for the episode.
  /// ⮕ [ This tag is used to link to a transcript or closed captions file. Multiple tags can be present for multiple transcript formats. Detailed file format information and example files are here. ]
  ///
  List<Map<String, dynamic>>? transcripts;

  ///
  /// Soundbite for episode
  ///
  Map<String, dynamic>? soundbite;

  ///
  /// Soundbites for episode
  /// ⮕ [ Soundbite for episode ]
  ///
  List<Map<String, dynamic>>? soundbites;

  ///
  /// List of people with an interest in this episode.
  ///
  /// See the podcast namespace spec for more information.
  ///
  List<Map<String, dynamic>>? persons;

  ///
  /// List the social interact data found in the podcast feed.
  ///
  /// See the podcast namespace spec for more information.
  ///
  List<Map<String, dynamic>>? socialInteract;

  ///
  /// Information for supporting the podcast via one of the "Value for Value" methods.
  ///
  /// Examples:
  ///
  /// lightning value type: https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=169991&pretty
  /// webmonetization value type: https://api.podcastindex.org/api/1.0/podcasts/byfeedid?id=779873&pretty
  Map<String, dynamic>? value;

  Episode(
    this.id,
    this.title,
    this.link,
    this.description,
    this.guid,
    this.datePublished,
    this.datePublishedPretty,
    this.dateCrawled,
    this.enclosureUrl,
    this.enclosureType,
    this.enclosureLength,
    this.duration,
    this.explicit,
    this.episode,
    this.episodeType,
    this.season,
    this.image,
    this.feedItunesId,
    this.feedImage,
    this.feedId,
    this.feedLanguage,
    this.feedDead,
    this.feedDuplicateOf,
    this.chaptersUrl,
    this.transcriptUrl,
    this.transcripts,
    this.soundbite,
    this.soundbites,
    this.persons,
    this.socialInteract,
    this.value,
  );

  static Episode fromJson(Map<String, dynamic> value) {
    return Episode(
      value["id"],
      value["title"],
      value["link"],
      value["description"],
      value["guid"],
      value["datePublished"],
      value["datePublishedPretty"],
      value["dateCrawled"],
      value["enclosureUrl"],
      value["enclosureType"],
      value["enclosureLength"],
      value["duration"],
      value["explicit"],
      value["episode"],
      value["episodeType"],
      value["season"],
      value["image"],
      value["feedItunesId"],
      value["feedImage"],
      value["feedId"],
      value["feedLanguage"],
      value["feedDead"],
      value["feedDuplicateOf"],
      value["chaptersUrl"],
      value["transcriptUrl"],
      value["transcripts"],
      value["soundbite"],
      value["soundbites"],
      value["persons"],
      value["socialInteract"],
      value["value"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "title": title,
      "link": link,
      "description": description,
      "guid": guid,
      "datePublished": datePublished,
      "datePublishedPretty": datePublishedPretty,
      "dateCrawled": dateCrawled,
      "enclosureUrl": enclosureUrl,
      "enclosureType": enclosureType,
      "enclosureLength": enclosureLength,
      "duration": duration,
      "explicit": explicit,
      "episode": episode,
      "episodeType": episodeType,
      "season": season,
      "image": image,
      "feedItunesId": feedItunesId,
      "feedImage": feedImage,
      "feedId": feedId,
      "feedLanguage": feedLanguage,
      "feedDead": feedDead,
      "feedDuplicateOf": feedDuplicateOf,
      "chaptersUrl": chaptersUrl,
      "transcriptUrl": transcriptUrl,
      "transcripts": transcripts,
      "soundbite": soundbite,
      "soundbites": soundbites,
      "persons": persons,
      "socialInteract": socialInteract,
      "value": value,
    };
  }
}
