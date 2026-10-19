import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/noticia_model.dart';
import '../models/comentario_model.dart';

class NoticiaService {
  static const String _endpoint = 'https://jsonplaceholder.typicode.com/posts';

  Future<List<NoticiaModel>> buscarNoticias() async {
    final response = await http.get(Uri.parse(_endpoint));

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((item) => NoticiaModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar notícias');
    }
  }

  Future<List<ComentarioModel>> buscarComentarios(int postId) async {
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/posts/$postId/comments'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> listaJson = jsonDecode(response.body);
      return listaJson.map((item) => ComentarioModel.fromJson(item)).toList();
    } else {
      throw Exception('Erro ao carregar comentários');
    }
  }
}
