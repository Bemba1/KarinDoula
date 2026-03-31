import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/services.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PagesReaderPage extends StatefulWidget {
  final dynamic chapterId;

  const PagesReaderPage({
    super.key,
    required this.chapterId,
  });

  @override
  State<PagesReaderPage> createState() => _PagesReaderPageState();
}
//Ajout
String optimizeImage(String url) {
  return url.replaceFirst(
    '/upload/',
    '/upload/w_800,q_auto,f_auto/',
  );
}
//
class _PagesReaderPageState extends State<PagesReaderPage> {
  int lastPrecachedIndex = -1;
  @override
  void initState() {
    super.initState();

    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
    );
    super.dispose();
  }

  Future<List<dynamic>> getPages() async {
    final response = await Supabase.instance.client
        .from('pages')
        .select()
        .eq('chapter_id', widget.chapterId)
        .order('page_number', ascending: true);

    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: FutureBuilder(
        future: getPages(),
        builder: (context, snapshot) {

          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final pages = snapshot.data as List;

          return MediaQuery.removePadding(
            context: context,
            removeTop: true,
            child: ListView.builder(
              itemCount: pages.length,
              itemBuilder: (context, index) {

                final page = pages[index];
                //Ajout
                if (index + 1 < pages.length && lastPrecachedIndex < index + 1) {
                  lastPrecachedIndex = index + 1;

                  final nextPage = pages[index + 1];

                  precacheImage(
                    NetworkImage(optimizeImage(nextPage['image_url'])),
                    context,
                  );
                }

                //
                print(page['page_number']);

                /// 🔥 PRÉCHARGEMENT DES PAGES SUIVANTES
                /*for (int i = 1; i <= 3; i++) {
                  if (index + i < pages.length) {
                    final nextPage = pages[index + i];

                    precacheImage(
                      NetworkImage(optimizeImage(nextPage['image_url'])),
                      context,
                    );
                  }
                }*/

                return CachedNetworkImage(
                  imageUrl: optimizeImage(page['image_url']),
                  memCacheWidth: 800,
                  fit: BoxFit.cover,

                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),

                  errorWidget: (context, url, error) =>
                  const Icon(Icons.error),
                );
              },
            ),
          );
        },
      ),
    );
  }
}