import 'dart:math';

import 'package:flutter/material.dart';
import 'package:peaceinapod/podcastindex/models/podcast.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:peaceinapod/widgets/image.dart';
import 'package:provider/provider.dart';

class PodcastDetailsWidget extends StatelessWidget {
  final Podcast podcast;

  final Duration imageFadeDuration = const Duration(milliseconds: 150);

  const PodcastDetailsWidget(this.podcast, {super.key});

  @override
  Widget build(BuildContext context) {
    double imageSize = min(
      300,
      min(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height / 2,
      ),
    );
    print(MediaQuery.of(context).size.width);
    return Consumer<PIndexProvider>(
      builder: (context, provider, child) {
        bool subscribed =
            provider.podcasts.where((e) => e.id == podcast.id).isNotEmpty;
        return Card(
          child: Container(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () => Navigator.pop(context),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Icon(Icons.arrow_back),
                      Text(podcast.title)
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                PodNetworkImage(
                  url: podcast.artwork,
                  // width: imageSize,
                  height: imageSize,
                  errorWidget: Container(
                    color: Colors.black.withOpacity(0.9),
                    width: imageSize,
                    height: imageSize,
                  ),
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: subscribed
                        ? Theme.of(context).colorScheme.onError
                        : null,
                  ),
                  onPressed: subscribed
                      ? () => provider
                          .unSubscribe(podcast)
                          .then((value) => Navigator.pop(context))
                      : () => provider
                          .subscribe(podcast)
                          .then((value) => Navigator.pop(context)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        subscribed ? "Unsubscribe" : "Subscribe",
                      ),
                      subscribed
                          ? const Icon(Icons.remove)
                          : const Icon(Icons.add)
                    ],
                  ),
                ),
                const SizedBox(height: 12.0),
                Expanded(
                  child: _podcastDescription(context),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  ListView _podcastDescription(BuildContext context) {
    return ListView(
      children: [
        Text(podcast.description),
        const SizedBox(height: 50.0),

        // Categories
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: podcast.categories == null
              ? [Container()]
              : podcast.categories!.values
                  .map(
                    (category) => Container(
                      padding: const EdgeInsets.fromLTRB(5, 0, 5, 0),
                      decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      child: Text("#$category"),
                    ),
                  )
                  .toList(),
        ),

        const SizedBox(height: 12.0),
        Text("Episodes: ${podcast.episodeCount}"),
        Text(
          "Latest episode: ${DateTime.fromMillisecondsSinceEpoch(podcast.newestItemPubdate * 1000)}",
        ),

        const SizedBox(height: 12.0),
        Text("Author: ${podcast.author}"),
        Text("Owner: ${podcast.ownerName}"),
        Text("Website: ${podcast.link}"),

        const SizedBox(height: 12.0),
        Text("Explicit: ${podcast.explicit ? 'Yes' : 'No'}"),
        Text("Language: ${podcast.language}"),
        Text("Dead: ${podcast.dead == 0 ? 'No' : 'Yes'}"),
      ],
    );
  }
}
