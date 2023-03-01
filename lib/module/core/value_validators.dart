String getIdFromUrl(String url, [bool trimWhitespaces = true]) {
  List<RegExp> _regexps = [
    RegExp(
        r'^https:\/\/(?:www\.|m\.)?youtube\.com\/watch\?v=([_\-a-zA-Z0-9]{11}).*$'),
    RegExp(
        r'^https:\/\/(?:www\.|m\.)?youtube(?:-nocookie)?\.com\/embed\/([_\-a-zA-Z0-9]{11}).*$'),
    RegExp(r'^https:\/\/youtu\.be\/([_\-a-zA-Z0-9]{11}).*$')
  ];

  if (url.isEmpty) {
    return null!;
  }

  if (trimWhitespaces) {
    url = url.trim();
  }

  for (RegExp exp in _regexps) {
    final Match match = exp.firstMatch(url) as Match;
    if (match != null && match.groupCount >= 1) {
      return match.group(1).toString();
    }
  }

  return null!;
}
