import 'package:flutter/material.dart';
import 'package:peaceinapod/constants/colors.dart';
import 'package:peaceinapod/pages/home_page/home_page.dart';
import 'package:peaceinapod/podcastindex/api.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:peaceinapod/widgets/about_widget.dart';
import 'package:provider/provider.dart';

class StartPage extends StatelessWidget {
  const StartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(12.0),
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Center(
                      child: Image.asset(
                        "assets/peaceinapod.png",
                        height: MediaQuery.of(context).size.height / 3,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(top: 24),
                      child: Text(
                        "peaceinapod",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                ElevatedButton(
                  onPressed: () =>
                      Provider.of<PIndexProvider>(context, listen: false)
                          .init()
                          .then((value) => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const HomePage(),
                                ),
                              )),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(120, 40),
                    backgroundColor: piapGreen,
                  ),
                  child: const Text("Start listening"),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: TextButton(
                onPressed: () => showBottomSheet(
                  context: context,
                  builder: (context) => const AboutWidget(),
                ),
                child: const Text(
                  "Huh?",
                  style: TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
