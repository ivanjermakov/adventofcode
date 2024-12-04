{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
    LOCALE_ARCHIVE = "${pkgs.glibcLocales}/lib/locale/locale-archive";
    nativeBuildInputs = with pkgs; [
        # day 1
        nasm
        # day 2
        cbqn
        clojure
        clojure-lsp
        # day 3
        # broken installation on nix
        # dmd
    ];
}
