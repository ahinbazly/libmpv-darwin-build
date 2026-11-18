{
  pkgs ? import ../default/pkgs.nix,
  os ? import ../default/os.nix,
  arch ? pkgs.callPackage ../default/arch.nix { },
}:

pkgs.runCommand "mk-cross-file-${os}-${arch}.ini" { } ''
  cp ${../../../cross-files/${os}-${arch}.ini} cross-file.ini
  sed -i "s|/Applications/Xcode.app|${pkgs.darwin.xcode}|g" cross-file.ini
  # Xcode 26 libc++ rejects legacy _LIBCPP_ENABLE_ASSERTIONS from some dependencies.
  sed -i "s|'-stdlib=libc++'|'-stdlib=libc++', '-U_LIBCPP_ENABLE_ASSERTIONS'|g" cross-file.ini
  cp cross-file.ini $out
''
