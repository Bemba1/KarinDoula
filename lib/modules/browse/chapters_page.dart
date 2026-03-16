import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages_reader_page.dart';

class ChaptersPage extends StatefulWidget {
  final dynamic comicId;
  final String title;

  const ChaptersPage({
    super.key,
    required this.comicId,
    required this.title,
  });

  @override
  State<ChaptersPage> createState() => _ChaptersPageState();
}

class _ChaptersPageState extends State<ChaptersPage> {

  Future<List<dynamic>> getChapters() async {
    final response = await Supabase.instance.client
        .from('chapters')
        .select()
        .eq('comic_id', widget.comicId);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: FutureBuilder(
        future: getChapters(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final chapters = snapshot.data as List;

          return ListView.builder(
            itemCount: chapters.length,
            itemBuilder: (context, index) {

              final chapter = chapters[index];

              return ListTile(
                title: Text("Chapter ${chapter['chapter_number']}"),
                subtitle: Text(chapter['title'] ?? ""),

                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PagesReaderPage(
                        chapterId: chapter['id'],
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