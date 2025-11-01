class NewsArticles {
  final String? title;
  final String? description;
  final String? url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  final Source? source;

  NewsArticles ({
    this.title,
    this.description,
    this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.source
  });

  factory NewsArticles.fromJson(Map<String, dynamic> json) {
    return NewsArticles(
      title: json['title'], 
      description: json['description'], 
      url: json['url'], 
      urlToImage: json['urlToImage'], 
      publishedAt: json['publishedAt'] != null
      ? DateTime.tryParse(json['publishedAt'])
      : null, 
      // jadi ini tuh biar dia 
      content: json['content'], 
      source: json['source'] != null? Source.fromJson(json['source']) : null,
      );
  }

  Map<String, dynamic> tolJson(){
    return {
      'title': title,
      'description': description,
      'url': url,
      'urlToImage': urlToImage,
      'publishedAt': publishedAt,
      'content': content,
      'source': source?.tolJson(),
    };
  }
}

class Source {
  final String? id;
  final String? name;

  Source({this.id, this.name});

// berfungsi untuk merapihkan format data yang didapatkan dari server
// yang awalnya bertipe data .json menjadi data yang di mengerti oleh bahasa pemograman yang di gunakan
  factory Source.fromJson(Map<String, dynamic> json) {
    return Source(
      id: json['id'],
      name: json['name'],
    );
  }

  Map<String, dynamic> tolJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}