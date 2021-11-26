import 'dart:convert';

import 'package:flutter/material.dart';

void main() {
  runApp(const MiCardApp());
}

const layoutSpacer = SizedBox(
  height: 20,
  width: 40,
);

class MiCardApp extends StatefulWidget {
  const MiCardApp({Key? key}) : super(key: key);

  @override
  _MiCardAppState createState() => _MiCardAppState();
}

class _MiCardAppState extends State<MiCardApp> {
  String headline = "";
  String name = "";
  String phone = "";
  String email = "";
  String website = "";
  String error = "";
  bool isLoading = true;

  Future<void> loadProfile() async {
    final file =
        await DefaultAssetBundle.of(context).loadString("data/profile.json");
    final data = json.decode(file);
    setState(() {
      headline = data["headline"];
      name = data["name"];
      phone = data["phone"];
      email = data["email"];
      website = data["website"];
    });
  }

  Future<void> delayedReveal() async {
    await Future.delayed(const Duration(seconds: 1));
    return;
  }

  @override
  Widget build(BuildContext context) {
    // Start reading the file async with render
    // setState will update the view on read completion
    loadProfile().catchError((e) {
      setState(() {
        error = e.toString();
      });
    }).then((x) {
      delayedReveal().then((x) {
        setState(() {
          isLoading = false;
        });
      });
    });

    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.cyan.shade800,
        body: SafeArea(
          child: LoadingBox(
            isLoading: isLoading,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  minRadius: 50,
                  maxRadius: 100,
                  backgroundColor: Colors.white,
                  backgroundImage: AssetImage('images/me.png'),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Text(
                    name,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 40,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'DancingScript',
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  child: Text(
                    headline,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.normal,
                      fontFamily: 'UbuntuCond',
                      letterSpacing: 4,
                      color: Colors.cyan.shade100,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                  width: 200,
                  child: Divider(
                    thickness: 1,
                    color: Colors.cyan.shade100,
                  ),
                ),
                DataCard(
                  icon: Icons.phone,
                  value: phone,
                ),
                DataCard(
                  icon: Icons.email,
                  value: email,
                ),
                DataCard(
                  icon: Icons.link,
                  value: website,
                ),
                Text(error, style: const TextStyle(color: Colors.red)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class LoadingBox extends StatelessWidget {
  final Widget child;
  final bool isLoading;

  const LoadingBox({Key? key, required this.child, required this.isLoading})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 5,
              )
            ],
          ),
          const SizedBox(height: 50),
          const Text(
            "LOADING",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 40,
              color: Colors.white,
              letterSpacing: 10,
              fontWeight: FontWeight.bold,
              fontFamily: 'UbuntuCond',
            ),
          ),
        ],
      );
    }
    return child;
  }
}

class DataCard extends StatelessWidget {
  final IconData icon;
  final String value;

  const DataCard({
    this.icon = Icons.add,
    this.value = '',
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      shadowColor: Colors.cyan.shade900,
      margin: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 25,
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: Colors.cyan.shade600,
        ),
        title: Text(
          value,
          style: TextStyle(
              color: Colors.cyan.shade600,
              fontSize: 25,
              fontFamily: "UbuntuCond"),
        ),
      ),
    );
  }
}
