import 'package:flutter_test/flutter_test.dart';
import 'package:aula11_master_detail/models/noticia_model.dart';
import 'package:aula11_master_detail/models/comentario_model.dart';
import 'package:aula11_master_detail/screens/detalhe_noticia_screen.dart';
import 'package:flutter/material.dart';

void main() {
  test('NoticiaModel deve converter de JSON corretamente', () {
    final json = {
      'id': 1,
      'title': 'Notícia de Teste',
      'body': 'Este é o corpo do texto da notícia de teste que deve ser resumido.',
      'userId': 2,
    };

    final noticia = NoticiaModel.fromJson(json);

    expect(noticia.id, 1);
    expect(noticia.titulo, 'Notícia de Teste');
    expect(noticia.autor, 'Autor ID 2');
    expect(noticia.conteudoCompleto, 'Este é o corpo do texto da notícia de teste que deve ser resumido.');
    expect(noticia.resumo, 'Este é o corpo do texto da notícia de te...');
  });

  test('ComentarioModel deve converter de JSON corretamente', () {
    final json = {
      'postId': 1,
      'id': 10,
      'name': 'João Silva',
      'email': 'joao@email.com',
      'body': 'Excelente matéria!',
    };

    final comentario = ComentarioModel.fromJson(json);

    expect(comentario.postId, 1);
    expect(comentario.id, 10);
    expect(comentario.nome, 'João Silva');
    expect(comentario.email, 'joao@email.com');
    expect(comentario.corpo, 'Excelente matéria!');
  });

  testWidgets('DetalheNoticiaScreen exibe as informações da notícia', (WidgetTester tester) async {
    final noticia = NoticiaModel(
      id: 99,
      titulo: 'Título Especial',
      resumo: 'Resumo especial...',
      conteudoCompleto: 'Conteúdo detalhado da notícia de teste.',
      autor: 'Autor ID 5',
      urlImagem: 'https://via.placeholder.com/150',
    );

    await tester.pumpWidget(
      MaterialApp(
        home: DetalheNoticiaScreen(noticia: noticia),
      ),
    );

    expect(find.text('Título Especial'), findsOneWidget);
    expect(find.text('Autor ID 5'), findsOneWidget);
    expect(find.text('Conteudo detalhado da notícia de teste.'), findsNothing); // wait: Conteúdo detalhado da notícia de teste.
    expect(find.text('Conteúdo detalhado da notícia de teste.'), findsOneWidget);
  });
}
