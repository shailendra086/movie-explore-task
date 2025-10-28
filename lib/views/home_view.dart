import 'package:flutter/material.dart';
import 'movie_list_view.dart';
import 'search_view.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/theme_provider.dart';

class HomeView extends ConsumerWidget {
  const HomeView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Movie Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SearchView())),
          ),
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => ref.read(themeNotifierProvider.notifier).toggle(),
          ),
        ],
      ),
      body: const MovieListView(),
    );
  }
}
