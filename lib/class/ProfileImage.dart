class ProfileImageModel {
  final String name;
  final String? downloadUrl;

  ProfileImageModel({
    required this.name,
    this.downloadUrl,
  });

  factory ProfileImageModel.fromJson(Map<String, dynamic> json) {
    return ProfileImageModel(
      name: json['name'],
      downloadUrl: json['downloadUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'downloadUrl': downloadUrl,
    };
  }
}
