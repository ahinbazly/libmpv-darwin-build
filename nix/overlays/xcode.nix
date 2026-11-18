final: prev: {
  darwin = prev.darwin.overrideScope (
    dFinal: dPrev: {
      xcode_16_1 = dPrev.xcode.overrideAttrs (old: {
        outputHash = "sha256-1jyRJVyOmGA7fxRwBnxSJatnOFDu01RJ9aAQXJNuWBw=";
      });

      # CI sets SUBX_XCODE_STORE to `nix-store --add-fixed` of /Applications/Xcode.app
      # so we do not depend on a pinned /nix/store/... path from a specific runner image.
      xcode =
        let
          fromCi = builtins.getEnv "SUBX_XCODE_STORE";
        in
        if fromCi != "" then
          prev.runCommand "Xcode.app"
            {
              preferLocalBuild = true;
              allowSubstitutes = false;
            }
            ''
              ln -s ${fromCi} $out
            ''
        else
          dFinal.xcode_16_1;
    }
  );
}