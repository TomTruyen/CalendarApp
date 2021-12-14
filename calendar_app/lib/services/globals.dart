class Globals {
  static final Globals _global = Globals._internal();

  factory Globals() {
    return _global;
  }

  Globals._internal();

  bool isDarkMode = false;
}
