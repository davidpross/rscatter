{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  buildInputs = [
    pkgs.R
    pkgs.rPackages.arrow
    pkgs.rPackages.htmlwidgets
    pkgs.rPackages.knitr
    pkgs.rPackages.pkgdown
    pkgs.rPackages.rmarkdown
    pkgs.rPackages.testthat
    pkgs.gettext
    pkgs.pandoc
  ];

  shellHook = ''
    echo "*** rscatter dev environment loaded ***"
  '';
}
