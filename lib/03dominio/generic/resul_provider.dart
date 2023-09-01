class ResulProvider {
  final String state;
  final String message;
  String? code;
  Object? obj;
  ResulProvider({
    required this.message,
    required this.state,
    this.code,
    this.obj,
  });
}
