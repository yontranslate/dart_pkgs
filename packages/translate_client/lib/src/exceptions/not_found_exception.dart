class NotFoundException implements Exception {
  final String message;

  NotFoundException({this.message});

  Map<String, dynamic> toJson() {
    return {
      'message': this.message,
    };
  }
}
