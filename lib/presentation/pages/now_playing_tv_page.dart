import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/presentation/provider/now_playing_tv_notifier.dart';
import 'package:ditonton/presentation/widgets/tv_card_list.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NowPlayingTVPage extends StatefulWidget {
  static const routeName = '/now-playing-tv';

  const NowPlayingTVPage({Key? key}) : super(key: key);

  @override
  NowPlayingTVPageState createState() => NowPlayingTVPageState();
}

class NowPlayingTVPageState extends State<NowPlayingTVPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      Provider.of<NowPlayingTVNotifier>(context, listen: false)
          .fetchNowPlayingTV();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Now Playing TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<NowPlayingTVNotifier>(
          builder: (context, data, child) {
            if (data.state == RequestState.loading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (data.state == RequestState.loaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = data.tvList[index];
                  return TVCard(tv);
                },
                itemCount: data.tvList.length,
              );
            } else {
              return Center(
                key: const Key('error_message'),
                child: Text(data.message),
              );
            }
          },
        ),
      ),
    );
  }
}
