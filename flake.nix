{
  description = "A flake for R development - Ralget";
  inputs = {
   nixpkgs.url = "nixpkgs/nixos-21.11";
   flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, ... }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs {
        inherit system;
        config = {allowUnfree = true;};
        };
      lib = nixpkgs.lib;
      my-r-pkgs  = pkgs.rWrapper.override {
        packages = with pkgs.rPackages; [
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
              data_table
              covr
              DT
              languageserver
              dagitty
              ggforce
              conflicted
              ggdag
              microbenchmark
              DiagrammeR
              glue
              igraph
              plogr
              readr
              Hmisc
          ];
      };
    in {
    devShell."x86_64-linux" = pkgs.mkShell {
    buildInputs = with pkgs; [ pandoc git  glibcLocales openssl which openssh curl wget  ];
    inputsFrom = [ my-r-pkgs ];
    shellHook = ''
      mkdir -p "$(pwd)/_libs"
      export R_LIBS_USER="$(pwd)/_libs"
      export PS1="FLAKE>"
    '';
    };
    };
}
