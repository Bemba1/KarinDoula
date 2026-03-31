import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chapters_page.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

class SupabaseComicsPage extends StatefulWidget {
  const SupabaseComicsPage({super.key});

  @override
  State<SupabaseComicsPage> createState() => _SupabaseComicsPageState();
}

class _SupabaseComicsPageState extends State<SupabaseComicsPage> {

  //ajout
  Widget _buildComicItem(dynamic comic) {
    return GestureDetector(
      onTap: () {
        context.push(
          "/chapters",
          extra: {
            "id": comic['id'],
            "title": comic['title'],
          },
        );
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: AspectRatio(
          aspectRatio: 9 / 16,
          child: CachedNetworkImage(
            imageUrl: comic['cover_url'],
            fit: BoxFit.cover,
            width: double.infinity,

            placeholder: (context, url) =>
            const Center(child: CircularProgressIndicator()),

            errorWidget: (context, url, error) =>
            const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
  //

  Future<List<dynamic>> getComics() async {
    final response = await Supabase.instance.client
        .from('comics')
        .select();

    return response;

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Supabase Comics"),
      ),
      body: FutureBuilder(
        future: getComics(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final comics = snapshot.data as List;

          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 80),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 🔥 3 colonnes
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
              childAspectRatio: 9 / 16, // 🔥 ratio manga
            ),
            itemCount: comics.length,
            itemBuilder: (context, index) {
              final comic = comics[index];

              return _buildComicItem(comic);
            },
          );
        },
      ),
    );
  }
}