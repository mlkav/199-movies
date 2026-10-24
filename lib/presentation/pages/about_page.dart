import 'package:core/core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  static const routeName = '/about';

  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  color: kPrussianBlue,
                  child: Center(
                    child: Image.asset(
                      'assets/circle-g.png',
                      width: 128,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(32.0),
                  color: kMikadoYellow,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Ditonton merupakan sebuah aplikasi katalog film yang dikembangkan oleh Dicoding Indonesia sebagai contoh proyek aplikasi untuk kelas Menjadi Flutter Developer Expert.',
                        style: TextStyle(color: Colors.black87, fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () => FirebaseCrashlytics.instance.crash(),
                        icon: const Icon(Icons.bug_report),
                        label:
                            const Text('Uji Crashlytics (aplikasi akan crash)'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SafeArea(
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
            ),
          )
        ],
      ),
    );
  }
}
