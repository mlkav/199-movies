import 'package:core/common/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_bloc.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_event.dart';
import 'package:tv/presentation/bloc/watchlist_tv/watchlist_tv_state.dart';
import 'package:tv/presentation/widgets/tv_card_list.dart';

class WatchlistTVPage extends StatefulWidget {
  static const routeName = '/watchlist-tv';

  const WatchlistTVPage({Key? key}) : super(key: key);

  @override
  WatchlistTVPageState createState() => WatchlistTVPageState();
}

class WatchlistTVPageState extends State<WatchlistTVPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      if (!mounted) return;
      context.read<WatchlistTVBloc>().add(FetchWatchlistTV());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistTVBloc>().add(FetchWatchlistTV());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Watchlist TV Series'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<WatchlistTVBloc, WatchlistTVState>(
          builder: (context, state) {
            if (state is WatchlistTVLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is WatchlistTVLoaded) {
              if (state.tvList.isEmpty) {
                return const Center(
                  key: Key('empty_watchlist'),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.bookmark_border,
                        size: 64,
                        color: Colors.grey,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Watchlist is still empty',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Add your favorite TV series to your watchlist.',
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }
              return ListView.builder(
                itemBuilder: (context, index) {
                  final tv = state.tvList[index];
                  return TVCard(tv);
                },
                itemCount: state.tvList.length,
              );
            } else if (state is WatchlistTVError) {
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

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
