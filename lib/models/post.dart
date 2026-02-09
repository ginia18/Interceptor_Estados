class Post {
  final int id;
  final String title;
  final String body;

  Post({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int? ?? 0,
      title: (json['title'] as String?)?.trim() ?? 'Título no disponible',
      body: (json['body'] as String?)?.trim() ?? 'Sin contenido disponible',
    );
  }
}