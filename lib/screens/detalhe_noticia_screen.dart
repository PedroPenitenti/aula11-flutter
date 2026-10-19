import 'package:flutter/material.dart';
import '../models/noticia_model.dart';
import '../models/comentario_model.dart';
import '../services/noticia_service.dart';

class DetalheNoticiaScreen extends StatefulWidget {
  final NoticiaModel noticia;
  final bool isFavorito;

  const DetalheNoticiaScreen({
    super.key,
    required this.noticia,
    this.isFavorito = false,
  });

  @override
  State<DetalheNoticiaScreen> createState() => _DetalheNoticiaScreenState();
}

class _DetalheNoticiaScreenState extends State<DetalheNoticiaScreen> {
  late bool _isFavorito;
  final _service = NoticiaService();
  late Future<List<ComentarioModel>> _futureComentarios;

  @override
  void initState() {
    super.initState();
    _isFavorito = widget.isFavorito;
    // Desafio Avançado: chamada à API para carregar comentários da notícia
    _futureComentarios = _service.buscarComentarios(widget.noticia.id);
  }

  void _alternarFavorito() {
    setState(() {
      _isFavorito = !_isFavorito;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          _isFavorito
              ? 'Notícia adicionada aos favoritos!'
              : 'Notícia removida dos favoritos.',
        ),
        duration: const Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        // Desafio Intermediário: retorna o estado de favorito para a tela anterior
        Navigator.pop(context, _isFavorito);
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Detalhes da Notícia'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context, _isFavorito),
          ),
          actions: [
            // Desafio Intermediário: Botão de Favoritar com ícone de coração
            IconButton(
              icon: Icon(
                _isFavorito ? Icons.favorite : Icons.favorite_border,
                color: _isFavorito ? Colors.red : null,
              ),
              tooltip: _isFavorito ? 'Desfavoritar' : 'Favoritar',
              onPressed: _alternarFavorito,
            ),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Desafio Básico: Hero Animation na imagem
              Hero(
                tag: widget.noticia.id,
                child: Image.network(
                  widget.noticia.urlImagem,
                  width: double.infinity,
                  height: 180,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 180,
                    color: Colors.grey[300],
                    child: const Icon(Icons.image, size: 40),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Chip(
                      avatar: const Icon(Icons.person, size: 16),
                      label: Text(widget.noticia.autor),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      widget.noticia.titulo,
                      style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const Divider(height: 24),
                    Text(
                      widget.noticia.conteudoCompleto,
                      style: Theme.of(context)
                          .textTheme
                          .bodyLarge
                          ?.copyWith(height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    const Divider(height: 32, thickness: 1.2),

                    // Desafio Avançado: Seção de comentários carregados via API
                    Row(
                      children: [
                        const Icon(Icons.comment_outlined, size: 22),
                        const SizedBox(width: 8),
                        Text(
                          'Comentários',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    FutureBuilder<List<ComentarioModel>>(
                      future: _futureComentarios,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 24.0),
                              child: CircularProgressIndicator(),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            child: Text(
                              'Erro ao carregar comentários: ${snapshot.error}',
                              style: const TextStyle(color: Colors.red),
                            ),
                          );
                        } else if (!snapshot.hasData ||
                            snapshot.data!.isEmpty) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 12.0),
                            child: Text('Nenhum comentário disponível.'),
                          );
                        }

                        final comentarios = snapshot.data!;
                        return ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: comentarios.length,
                          separatorBuilder: (context, index) =>
                              const Divider(height: 16),
                          itemBuilder: (context, index) {
                            final comentario = comentarios[index];
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 16,
                                    backgroundColor: Theme.of(context)
                                        .colorScheme
                                        .primaryContainer,
                                    child: Text(
                                      comentario.nome.isNotEmpty
                                          ? comentario.nome[0].toUpperCase()
                                          : '?',
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onPrimaryContainer,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          comentario.nome,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          comentario.email,
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          comentario.corpo,
                                          style: const TextStyle(fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
