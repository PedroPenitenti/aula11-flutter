class NoticiaModel {
  final int id;
  final String titulo;
  final String resumo;
  final String conteudoCompleto;
  final String autor;
  final String urlImagem;

  NoticiaModel({
    required this.id,
    required this.titulo,
    required this.resumo,
    required this.conteudoCompleto,
    required this.autor,
    required this.urlImagem,
  });

  factory NoticiaModel.fromJson(Map<String, dynamic> json) {
    final String body = json['body'] as String? ?? '';
    final String resumoTexto = body.isNotEmpty
        ? (body.length > 40 ? '${body.substring(0, 40)}...' : body)
        : '';

    return NoticiaModel(
      id: json['id'] ?? 0,
      titulo: json['title'] ?? 'Sem título',
      resumo: resumoTexto,
      conteudoCompleto: body.isNotEmpty ? body : 'Sem conteúdo disponível.',
      autor: 'Autor ID ${json['userId']?.toString() ?? '1'}',
      urlImagem: json['urlImagem'] ?? 'https://picsum.photos/seed/${json['id'] ?? 1}/600/300',
    );
  }
}
