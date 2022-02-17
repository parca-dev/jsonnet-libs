local validLabelChars = ['a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm', 'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z', 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z', '0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '_'];

{
  // sanitizeLabelName sanitizes a given string to be used as a Parca label name.
  // Jsonnet equivalent of: regexp.MustCompile(`[^a-zA-Z0-9_]`).ReplaceAllString(name, "_")
  sanitizeLabelName(name):
    std.join('', [
      if std.setMember(c, validLabelChars) then
        c
      else
        '_'
      for c in std.stringChars(name)
    ]),
}
