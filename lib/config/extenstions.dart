extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }

  String removeDash() {
   return this.replaceAll('-', ' ');
  }

  String replaceBackWardSlash() {
    return this.replaceAll('\\', '/');
  }
}