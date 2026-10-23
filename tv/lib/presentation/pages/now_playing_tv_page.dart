import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_bloc.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_event.dart';
import 'package:tv/presentation/bloc/now_playing_tv/now_playing_tv_state.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

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
      context.read<NowPlayingTVBloc>().add(FetchNowPlayingTV());
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
        child: BlocBuilder<NowPlayingTVBloc, NowPlayingTVState>(
          builder: (context, state) {
            if (state is NowPlayingTVLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is NowPlayingTVLoaded) {
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvList[index];
                  return TVCard(tv);
                },
                itemCount: state.tvList.length,
              );
            } else if (state is NowPlayingTVError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }
}
