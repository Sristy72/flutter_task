extension StringExtensions on String {
  bool get isEmail {
    return RegExp(
      r'^[^@]+@[^@]+\.[^@]+',
    ).hasMatch(this);
  }

  bool get isEmptyOrNull {
    return trim().isEmpty;
  }

  String get capitalizeFirst {
    if (isEmpty) return this;

    return '${this[0].toUpperCase()}${substring(1)}';
  }
}