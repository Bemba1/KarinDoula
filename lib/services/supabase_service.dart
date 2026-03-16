import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {

  final SupabaseClient client = Supabase.instance.client;

  Future<List<dynamic>> getComics() async {
    final response = await client
        .from('comics')
        .select();

    return response;
  }

  Future<List<dynamic>> getChapters(int comicId) async {
    final response = await client
        .from('chapters')
        .select()
        .eq('comic_id', comicId);

    return response;
  }

  Future<List<dynamic>> getPages(int chapterId) async {
    final response = await client
        .from('pages')
        .select()
        .eq('chapter_id', chapterId)
        .order('page_number');

    return response;
  }
}