import 'package:flutter/material.dart';
import 'package:peaceinapod/podcastindex/tests.dart';

class TestPage extends StatefulWidget {
  const TestPage({super.key});

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  bool loading = true;
  List results = [];

  Future runTests() async {
    var res = PIndexTest().testSearch();
    return;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          ElevatedButton(
              onPressed: PIndexTest().testSearch, child: const Text("Search"))
        ],
      ),
    );
  }
}
