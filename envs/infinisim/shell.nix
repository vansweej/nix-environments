{
  pkgs ? import <nixpkgs> {},
  extraPkgs ? []
}:
pkgs.mkShell {
  nativeBuildInputs = with pkgs; [
    cmake
    gnumake
    SDL2
    libpng
    gcc14
    ccache
    libpng12
    (python3.withPackages(python: [
      python.pillow
    ]))
    lv_font_conv
  ] ++ extraPkgs;
}
