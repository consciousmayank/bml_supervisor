extension StringExtension on String {
  String capitalizeFirstLetter() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}

extension CapExtension on String {
  String get inCaps => '${this[0].toUpperCase()}${this.substring(1)}';
  String get allInCaps => this.toUpperCase();
  String get capitalizeFirstOfEach =>
      this.split(" ").map((str) => str.capitalizeFirstLetter).join(" ");
}
