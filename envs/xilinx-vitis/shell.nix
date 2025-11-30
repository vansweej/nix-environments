{ pkgs ? import <nixpkgs> { }
, extraPkgs ? [ ]
, runScript ? "bash"
, xilinxName ? "xilinx-env"
}:

(pkgs.buildFHSEnv {
  name = xilinxName;
  inherit runScript;
  targetPkgs = pkgs: with pkgs; let
    ncurses' = ncurses5.overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [ "--with-termlib" ];
      postFixup = "";
    });
    ncurses6' = ncurses6.overrideAttrs (old: {
      configureFlags = old.configureFlags ++ [ "--with-termlib" ];
      postFixup = "";
    });
  in
  [
    bash
    coreutils
    zlib
    lsb-release
    stdenv.cc.cc
    # https://github.com/NixOS/nixpkgs/issues/218534
    # postFixup would create symlinks for the non-unicode version but since it breaks
    # in buildFHSEnv, we just install both variants
    ncurses'
    (ncurses'.override { unicodeSupport = false; })
    ncurses6'
    (ncurses6'.override { unicodeSupport = false; })
    xorg.libXext
    xorg.libX11
    xorg.libXrender
    xorg.libXtst
    xorg.libXi
    xorg.libXft
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXdamage
    xorg.libXfixes
    xorg.libXrandr
    # common requirements
    freetype
    fontconfig
    glib
    gtk2
    gtk3
    libxcrypt-legacy # required for Vivado
    python3

    libuuid
    pixman
    libpng
    git
    gdb
    nss
    nspr
    dbus
    at-spi2-atk
    cups
    libdrm
    pango
    cairo
    libgbm
    expat
    libxkbcommon
    alsa-lib
    libglvnd
    sqlite
    gmp
    zstd
    libffi
    libsecret
    libxkbfile
    libyaml
    libudev0-shim

    (libidn.overrideAttrs (_old: {
      # we need libidn.so.11 but nixpkgs has libidn.so.12
      src = fetchurl {
        url = "mirror://gnu/libidn/libidn-1.34.tar.gz";
        sha256 = "sha256-Nxnil18vsoYF3zR5w4CvLPSrTpGeFQZSfkx2cK//bjw=";
      };
    }))

    # to compile some xilinx examples
    opencl-clhpp
    ocl-icd
    opencl-headers

    # from installLibs.sh
    graphviz
    (lib.hiPrio gcc)
    unzip
    nettools
  ] ++ extraPkgs;
  multiPkgs = ps: [];
  profile = ''
    export LC_NUMERIC="en_US.UTF-8"
    source /opt/xilinx/Vitis/*/settings64.sh
  '';
}).env
