import 'package:flutter/material.dart';
import '../models/noticia_model.dart';
import '../services/noticia_service.dart';
import 'detalhe_noticia_screen.dart';

class FeedNoticiasScreen extends StatefulWidget {
  const FeedNoticiasScreen({super.key});

  @override
  State<FeedNoticiasScreen> createState() => _FeedNoticiasScreenState();
}

class _FeedNoticiasScreenState extends State<FeedNoticiasScreen> {
  final _service = NoticiaService();
  late Future<List<NoticiaModel>> _futureNoticias;
  final Set<int> _favoritos = <int>{};

  @override
  void initState() {
    super.initState();
    _recarregarNoticias();
  }

  void _recarregarNoticias() {
    _futureNoticias = _service.buscarNoticias();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Portal de Notícias'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Recarregar',
            onPressed: () {
              setState(() {
                _recarregarNoticias();
              });
            },
          ),
        ],
      ),
      body: FutureBuilder<List<NoticiaModel>>(
        future: _futureNoticias,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 12),
                    Text(
                      'Erro: ${snapshot.error}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.red),
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        setState(() {
                          _recarregarNoticias();
                        });
                      },
                      icon: const Icon(Icons.refresh),
                      label: const Text('Tentar Novamente'),
                    ),
                  ],
                ),
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhuma notícia encontrada.'));
          }

          final noticias = snapshot.data!;
          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _recarregarNoticias();
              });
            },
            child: ListView.builder(
              itemCount: noticias.length,
              itemBuilder: (context, index) {
                final item = noticias[index];
                final isFavorito = _favoritos.contains(item.id);

                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  child: ListTile(
                    // Desafio Básico: Hero Animation na miniatura da imagem
                    leading: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Hero(
                        tag: item.id,
                        child: Image.network(
                          item.urlImagem,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 54,
                            height: 54,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image, size: 24),
                          ),
                        ),
                      ),
                    ),
                    title: Text(
                      item.titulo,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      item.resumo,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (isFavorito)
                          const Padding(
                            padding: EdgeInsets.only(right: 6.0),
                            child: Icon(Icons.favorite, color: Colors.red, size: 18),
                          ),
                        const Icon(Icons.arrow_forward_ios, size: 16),
                      ],
                    ),
                    onTap: () async {
                      // Passagem do objeto fortemente tipado NoticiaModel como parâmetro da rota
                      final resultadoFavorito = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DetalheNoticiaScreen(
                            noticia: item,
                            isFavorito: isFavorito,
                          ),
                        ),
                      );

                      // Desafio Intermediário: atualiza o estado com o retorno recebido
                      if (resultadoFavorito != null) {
                        setState(() {
                          if (resultadoFavorito) {
                            _favoritos.add(item.id);
                          } else {
                            _favoritos.remove(item.id);
                          }
                        });
                      }
                    },
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
