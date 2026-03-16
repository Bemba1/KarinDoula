import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'chapters_page.dart';

class SupabaseComicsPage extends StatefulWidget {
  const SupabaseComicsPage({super.key});

  @override
  State<SupabaseComicsPage> createState() => _SupabaseComicsPageState();
}

class _SupabaseComicsPageState extends State<SupabaseComicsPage> {

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

          return ListView.builder(
            itemCount: comics.length,
            itemBuilder: (context, index) {

              final comic = comics[index];

              return ListTile(
                leading: Image.network(
                  comic['cover_url'],
                  width: 50,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    print("Erreur image: ${comic['cover_url']}");
                    return const Icon(Icons.error);
                  },
                ),
                title: Text(comic['title']),
                subtitle: Text(comic['description'] ?? ''),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChaptersPage(
                        comicId: comic['id'],
                        title: comic['title'],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}