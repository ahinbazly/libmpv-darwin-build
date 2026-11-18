final: prev: {
  darwin = prev.darwin.overrideScope (
    final: prev: {
      xcode_16_1 = prev.xcode.overrideAttrs (old: {
        outputHash = "sha256-1jyRJVyOmGA7fxRwBnxSJatnOFDu01RJ9aAQXJNuWBw=";
      });

      # CI sets SUBX_XCODE_STORE to `nix-store --add-fixed` of /Applications/Xcode.app
      # so we do not depend on a pinned /nix/store/... path from a specific runner image.
      xcode =
        let
          fromCi = builtins.getEnv "SUBX_XCODE_STORE";
        in
        if fromCi != "" then
          prev.runCommandLocal "Xcode.app"
            {
              preferLocalBuild = true;
              allowSubstitutes = false;
            }
            ''
              ln -s ${fromCi} $out
            ''
        else
          final.xcode_16_1;
    }
  );
}