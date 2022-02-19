# shell.nix
{ pkgs ? import <nixpkgs> { } }:
with pkgs;
let
  my-r-pkgs = rWrapper.override {
    packages = with rPackages; [
      ggplot2
      tidyverse
      tidybayes
      tidygraph
      usethis
      ggraph
      devtools
      patchwork
      rmarkdown
      visNetwork
      stringi
      covr
      DT
      languageserver
      dagitty
      ggforce
      conflicted
      ggdag
      microbenchmark
      DiagrammeR
    ];
  };
in mkShell {
  buildInputs = with pkgs; [ rstudio emacs pandoc vscodium git glibcLocales openssl which openssh curl wget ];
  inputsFrom = [ my-r-pkgs ];
  shellHook = ''
    mkdir -p "$(pwd)/_libs"
    export R_LIBS_USER="$(pwd)/_libs"
  '';
  GIT_SSL_CAINFO = "${cacert}/etc/ssl/certs/ca-bundle.crt";
#  LOCALE_ARCHIVE = stdenv.lib.optionalString stdenv.isLinux
#    "${glibcLocales}/lib/locale/locale-archive";
}
