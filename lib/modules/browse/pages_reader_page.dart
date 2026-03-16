import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PagesReaderPage extends StatefulWidget {
  final dynamic chapterId;

  const PagesReaderPage({
    super.key,
    required this.chapterId,
  });

  @override
  State<PagesReaderPage> createState() => _PagesReaderPageState();
}

class _PagesReaderPageState extends State<PagesReaderPage> {

  Future<List<dynamic>> getPages() async {
    final response = await Supabase.instance.client
        .from('pages')
        .select()
        .eq('chapter_id', widget.chapterId)
        .order('page_number');

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reader"),
      ),
      body: FutureBuilder(
        future: getPages(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pages = snapshot.data as List;

          return ListView.builder(
            itemCount: pages.length,
            itemBuilder: (context, index) {

              final page = pages[index];

              return Image.network(
                page['image_url'],
                fit: BoxFit.cover,
              );
            },
          );
        },
      ),
    );
  }
}