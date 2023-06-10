{ writeScript
, makeWrapper
, symlinkJoin
, ffmpeg
, bash
, coreutils
}:
let
  script = writeScript "trim-screencast"
    ''
    #!${bash}/bin/bash
    input_file=$1
    filename=$(basename -- "$input_file")
    extension="''${filename##*.}"
    output_file="$filename-trimmed.$extension"

    ffmpeg -i "$input_file" -vf mpdecimate -vsync vfr -acodec copy "$output_file"
    '';
in
symlinkJoin {
  name = "trim-screencast";
  paths = [ bash ffmpeg coreutils ];
  buildInputs = [ makeWrapper ];
  postBuild = ''
  cp ${script} $out/bin/trim-screencast
  wrapProgram $out/bin/trim-screencast --set PATH $out/bin
  '';
}