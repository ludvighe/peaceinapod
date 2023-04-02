import 'package:flutter/material.dart';
import 'package:peaceinapod/constants/colors.dart';
import 'package:peaceinapod/pages/home_page/home_page.dart';
import 'package:peaceinapod/providers/podcastindex.provider.dart';
import 'package:peaceinapod/widgets/about_widget.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _keysExist = false;
  late TextEditingController _keyController;
  late TextEditingController _secretController;

  Future<void> initControllers() async {
    var prefs = await SharedPreferences.getInstance();
    String? key = prefs.getString("pindexkey");
    String? secret = prefs.getString("pindexsecret");
    if (key != null && secret != null) {
      _keyController.text = key;
      _secretController.text = secret;
      setState(() {
        _keysExist = true;
      });
    }
  }

  Future<void> resetControllers() async {
    var prefs = await SharedPreferences.getInstance();
    await prefs.remove("pindexkey");
    await prefs.remove("pindexsecret");
    setState(() {
      _keysExist = false;
      _keyController.text = "";
      _secretController.text = "";
    });
  }

  @override
  void initState() {
    _keyController = TextEditingController();
    _secretController = TextEditingController();
    initControllers();
    super.initState();
  }

  Future<void> login() async {
    String key = _keyController.text;
    String secret = _secretController.text;
    Provider.of<PIndexProvider>(context, listen: false).login(key, secret);
    var prefs = await SharedPreferences.getInstance();
    prefs.setString("pindexkey", key);
    prefs.setString("pindexsecret", secret);
    setState(() {
      _keysExist = true;
    });
  }

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
                Wrap(
                  runSpacing: 12.0,
                  alignment: WrapAlignment.center,
                  children: [
                    if (!_keysExist)
                      TextField(
                        decoration: const InputDecoration(
                          label: Text("Key"),
                        ),
                        controller: _keyController,
                        obscureText: true,
                      ),
                    if (!_keysExist)
                      TextField(
                        decoration: const InputDecoration(
                          label: Text("Secret"),
                        ),
                        controller: _secretController,
                        obscureText: true,
                      ),
                    Wrap(
                      spacing: 20.0,
                      runAlignment: WrapAlignment.center,
                      children: [
                        if (_keysExist)
                          ElevatedButton(
                            onPressed: resetControllers,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: piapBrown,
                              minimumSize: const Size(120, 40),
                            ),
                            child: const Text("Reset keys"),
                          ),
                        ElevatedButton(
                          onPressed: () =>
                              login().then((value) => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const HomePage()),
                                  )),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(120, 40),
                            backgroundColor: piapGreen,
                          ),
                          child: const Text("Login"),
                        ),
                      ],
                    )
                  ],
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
