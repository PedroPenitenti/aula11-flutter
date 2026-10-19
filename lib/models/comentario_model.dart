class ComentarioModel {
  final int postId;
  final int id;
  final String nome;
  final String email;
  final String corpo;

  ComentarioModel({
    required this.postId,
    required this.id,
    required this.nome,
    required this.email,
    required this.corpo,
  });

  factory ComentarioModel.fromJson(Map<String, dynamic> json) {
    return ComentarioModel(
      postId: json['postId'] ?? 0,
      id: json['id'] ?? 0,
      nome: json['name'] ?? 'Anônimo',
      email: json['email'] ?? '',
      corpo: json['body'] ?? '',
    );
  }
}
