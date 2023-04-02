class Podcast {
  ///
  /// The internal PodcastIndex.org Feed ID.
  ///
  int id;

  ///
  /// The GUID from the podcast:guid tag in the feed. This value is a unique, global identifier for the podcast.
  ///
  /// See the namespace spec for guid for details.
  ///
  String podcastGuid;

  ///
  /// Name of the feed
  ///
  String title;

  ///
  /// Current feed URL
  ///
  String url;

  ///
  /// The URL of the feed, before it changed to the current url value.
  ///
  String originalUrl;

  ///
  /// The channel-level link in the feed
  ///
  String link;

  ///
  /// The channel-level description
  ///
  /// Uses the longer of the possible fields in the feed: <description>, <itunes:summary> and <content:encoded>
  ///
  String description;

  ///
  /// The channel-level author element.
  ///
  /// Usually iTunes specific, but could be from another namespace if not present.
  ///
  String author;

  ///
  /// The channel-level owner:name element.
  ///
  /// Usually iTunes specific, but could be from another namespace if not present.
  ///
  String ownerName;

  ///
  /// The channel-level image element.
  ///
  String image;

  ///
  /// The seemingly best artwork we can find for the feed. Might be the same as image in most instances.
  ///
  String artwork;

  ///
  /// The channel-level pubDate for the feed, if it’s sane. If not, this is a heuristic value, arrived at by analyzing other parts of the feed, like item-level pubDates.
  ///
  int lastUpdateTime;

  ///
  /// The last time we attempted to pull this feed from its url.
  ///
  int lastCrawlTime;

  ///
  /// The last time we tried to parse the downloaded feed content.
  ///
  int lastParseTime;

  ///
  /// Timestamp of the last time we got a "good", meaning non-4xx/non-5xx, status code when pulling this feed from its url.
  ///
  int lastGoodHttpStatusTime;

  ///
  /// The last http status code we got when pulling this feed from its url.
  ///
  /// You will see some made up status codes sometimes. These are what we use to track state within the feed puller. These all start with 9xx.
  ///
  int lastHttpStatus;

  ///
  /// The Content-Type header from the last time we pulled this feed from its url.
  ///
  String contentType;

  ///
  /// The iTunes ID of this feed if there is one, and we know what it is.
  ///
  int? itunesId;

  ///
  /// The channel-level generator element if there is one.
  ///
  String generator;

  ///
  /// The channel-level language specification of the feed. Languages accord with the RSS Language Spec.
  ///
  String language;

  ///
  /// Is feed marked as explicit
  ///
  bool explicit;

  ///
  /// Type of source feed where:
  ///
  /// 0: RSS
  /// 1: Atom
  /// Allowed: 0┃1
  int type;

  ///
  /// At some point, we give up trying to process a feed and mark it as dead. This is usually after 1000 errors without a successful pull/parse cycle. Once the feed is marked dead, we only check it once per month.
  ///
  int dead;

  ///
  /// Number of episodes for this feed known to the index.
  ///
  int episodeCount;

  ///
  /// The number of errors we’ve encountered trying to pull a copy of the feed. Errors are things like a 500 or 404 response, a server timeout, bad encoding, etc.
  ///
  int crawlErrors;

  ///
  /// The number of errors we’ve encountered trying to parse the feed content. Errors here are things like not well-formed xml, bad character encoding, etc.
  ///
  /// We fix many of these types of issues on the fly when parsing. We only increment the errors count when we can’t fix it.
  ///
  int parseErrors;

  ///
  /// An array of categories, where the index is the Category ID and the value is the Category Name.
  ///
  /// All Category numbers and names are returned by the categories/list endpoint.
  ///
  Map<String, dynamic>? categories;

  ///
  /// Tell other podcast platforms whether they are allowed to import this feed. A value of 1 means that any attempt to import this feed into a new platform should be rejected. Contains the value of the feed's channel-level podcast:locked tag where:
  ///
  /// 0: 'no'
  /// 1: 'yes'
  /// Allowed: 0┃1
  int locked;

  ///
  /// A CRC32 hash of the image URL with the protocol (http://, https://) removed. Can be used to retrieve a resized/converted version of the image specified by image from https://podcastimages.com/.
  ///
  /// Using the format: https://podcastimages.com/<hash>_<size>.jpg Replace <hash> with the value in this field. The <size> is the desired image width/height. Ex: https://podcastimages.com/1011338142_600.jpg
  ///
  /// Work in Progress: the podcastimages.com system is currently not working.
  ///
  int imageUrlHash;

  ///
  /// The time the most recent episode in the feed was published.
  ///
  /// Note: some endpoints use newestItemPubdate while others use newestItemPublishTime. They return the same information. See https://github.com/Podcastindex-org/api/issues/3 to track when the property name is updated.
  int newestItemPubdate;

  Podcast(
    this.id,
    this.podcastGuid,
    this.title,
    this.url,
    this.originalUrl,
    this.link,
    this.description,
    this.author,
    this.ownerName,
    this.image,
    this.artwork,
    this.lastUpdateTime,
    this.lastCrawlTime,
    this.lastParseTime,
    this.lastGoodHttpStatusTime,
    this.lastHttpStatus,
    this.contentType,
    this.itunesId,
    this.generator,
    this.language,
    this.explicit,
    this.type,
    this.dead,
    this.episodeCount,
    this.crawlErrors,
    this.parseErrors,
    this.categories,
    this.locked,
    this.imageUrlHash,
    this.newestItemPubdate,
  );

  static Podcast fromJson(Map<String, dynamic> value) {
    return Podcast(
      value["id"],
      value["podcastGuid"],
      value["title"],
      value["url"],
      value["originalUrl"],
      value["link"],
      value["description"],
      value["author"],
      value["ownerName"],
      value["image"],
      value["artwork"],
      value["lastUpdateTime"],
      value["lastCrawlTime"],
      value["lastParseTime"],
      value["lastGoodHttpStatusTime"],
      value["lastHttpStatus"],
      value["contentType"],
      value["itunesId"],
      value["generator"],
      value["language"],
      value["explicit"],
      value["type"],
      value["dead"],
      value["episodeCount"],
      value["crawlErrors"],
      value["parseErrors"],
      value["categories"],
      value["locked"],
      value["imageUrlHash"],
      value["newestItemPubdate"],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "podcastGuid": podcastGuid,
      "title": title,
      "url": url,
      "originalUrl": originalUrl,
      "link": link,
      "description": description,
      "author": author,
      "ownerName": ownerName,
      "image": image,
      "artwork": artwork,
      "lastUpdateTime": lastUpdateTime,
      "lastCrawlTime": lastCrawlTime,
      "lastParseTime": lastParseTime,
      "lastGoodHttpStatusTime": lastGoodHttpStatusTime,
      "lastHttpStatus": lastHttpStatus,
      "contentType": contentType,
      "itunesId": itunesId,
      "generator": generator,
      "language": language,
      "explicit": explicit,
      "type": type,
      "dead": dead,
      "episodeCount": episodeCount,
      "crawlErrors": crawlErrors,
      "parseErrors": parseErrors,
      "categories": categories,
      "locked": locked,
      "imageUrlHash": imageUrlHash,
      "newestItemPubdate": newestItemPubdate,
    };
  }
}
