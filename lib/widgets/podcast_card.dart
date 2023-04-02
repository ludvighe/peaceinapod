import "package:cached_network_image/cached_network_image.dart";
import "package:flutter/material.dart";
import 'package:peaceinapod/podcastindex/models/podcast.dart';
import "package:peaceinapod/providers/podcastindex.provider.dart";
import "package:peaceinapod/widgets/podcast_details_widget.dart";
import "package:peaceinapod/widgets/podcast_episodes_widget.dart";

enum PodcastCardMode {
  preferAbout,
  preferEpisodes,
}

class PodcastCard extends StatelessWidget {
  final PIndexProvider provider;
  final Podcast podcast;

  final Size imageSize = const Size(60, 60);
  final Duration imageFadeDuration = const Duration(milliseconds: 150);

  final PodcastCardMode mode;

  const PodcastCard(this.provider, this.podcast,
      {super.key, this.mode = PodcastCardMode.preferAbout});

  void openAbout(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PodcastDetailsWidget(podcast),
    );
  }

  void openEpisodes(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => PodcastEpisodesWidget(podcast),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: mode == PodcastCardMode.preferAbout
            ? () => openAbout(context)
            : () => openEpisodes(context),
        onLongPress: mode == PodcastCardMode.preferAbout
            ? () => openEpisodes(context)
            : () => openAbout(context),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Hero(
                tag: "podcast_image_${podcast.id}",
                child: CachedNetworkImage(
                  imageUrl: podcast.artwork,
                  height: imageSize.height,
                  width: imageSize.width,
                  fadeInDuration: imageFadeDuration,
                  errorWidget: (context, url, error) => Icon(
                    Icons.podcasts,
                    size: imageSize.width,
                    color: Colors.grey,
                  ),
                ),
              ),
              const SizedBox(
                width: 12.0,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(podcast.title),
                    Text(
                      podcast.description,
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      "Latest episode: ${DateTime.fromMillisecondsSinceEpoch(podcast.newestItemPubdate * 1000).toString().split(' ')[0]}",
                      style: const TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
