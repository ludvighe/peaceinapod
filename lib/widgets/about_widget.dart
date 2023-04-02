import 'package:flutter/material.dart';
import 'package:peaceinapod/constants/colors.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.2,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            color: Colors.black.withOpacity(0.2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "About",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const Icon(Icons.swipe_down)
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "peaceinapod is a \"work in progress\" of a podcast app",
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Podcast Index",
                        style: TextStyle(
                          color: piapGreen,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const SelectableText(
                        "This app is using Podcast Index's API to get podcast information."
                        // "\n\nThe Key and Secret is therefore the credentials you can get at https://api.podcastindex.org/signup."
                        "\n\nA huge thank you to the amazing work from the people at Podcast Index for making this app possible. "
                        "\nPlease check out their website at https://podcastindex.org/."
                        "\n\n\nDonate to Podcast Index: https://podcastindex.org/.",
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
