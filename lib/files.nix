with builtins;
rec {
  regularFiles = path: let
    entries = readDir path;
    entryNames = attrNames entries;
    regularFilenames = filter (file: entries."${file}" == "regular") entryNames;
    in namesToPaths path regularFilenames;
  extFiles = path: ext: filter (file: (match ".*\.${ext}" "${file}") != null) (regularFiles path);
  namesToPaths = prefixPath: filenames: map (str: prefixPath + "/${str}") filenames;
}
