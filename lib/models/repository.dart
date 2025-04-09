class Repository {
  final int id;
  final String name;
  final String fullName;
  final String description;
  final RepositoryOwner owner;
  final String language;
  final int stargazersCount;
  final int watchersCount;
  final int forksCount;
  final int openIssuesCount;
  final String htmlUrl;

  Repository({
    required this.id,
    required this.name,
    required this.fullName,
    required this.description,
    required this.owner,
    required this.language,
    required this.stargazersCount,
    required this.watchersCount,
    required this.forksCount,
    required this.openIssuesCount,
    required this.htmlUrl,
  });

  factory Repository.fromJson(Map<String, dynamic> json) {
    return Repository(
      id: json['id'] as int,
      name: json['name'] as String,
      fullName: json['full_name'] as String,
      description: json['description'] as String? ?? '',
      owner: RepositoryOwner.fromJson(json['owner'] as Map<String, dynamic>),
      language: json['language'] as String? ?? 'Unknown',
      stargazersCount: json['stargazers_count'] as int,
      watchersCount: json['watchers_count'] as int,
      forksCount: json['forks_count'] as int,
      openIssuesCount: json['open_issues_count'] as int,
      htmlUrl: json['html_url'] as String,
    );
  }
}

class RepositoryOwner {
  final int id;
  final String login;
  final String avatarUrl;

  RepositoryOwner({
    required this.id,
    required this.login,
    required this.avatarUrl,
  });

  factory RepositoryOwner.fromJson(Map<String, dynamic> json) {
    return RepositoryOwner(
      id: json['id'] as int,
      login: json['login'] as String,
      avatarUrl: json['avatar_url'] as String,
    );
  }
}