import 'package:flutter/material.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:peaceinapod/widgets/podcast_card.dart';
import 'package:provider/provider.dart';

class SearchWidget extends StatelessWidget {
  SearchWidget({super.key});

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<PIndexProvider>(
      builder: (context, provider, child) => Column(
        children: [
          TextField(
            decoration: const InputDecoration(label: Icon(Icons.search)),
            autofocus: true,
            controller: _searchController,
            enabled: !provider.loading,
            onSubmitted: (value) => provider.searchPodcast(value),
          ),
          provider.loading
              ? const LinearProgressIndicator()
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: ListView(
                        children: provider.podcastSearch.isEmpty
                            ? const [Center(child: Text("No results"))]
                            : provider.podcastSearch
                                .map(
                                    (podcast) => PodcastCard(provider, podcast))
                                .toList()),
                  ),
                )
        ],
      ),
    );
  }
}
